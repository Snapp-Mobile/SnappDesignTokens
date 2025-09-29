//
//  DimensionUnit.swift
//
//  Created by Volodymyr Voiko on 10.03.2025.
//

import Foundation
import OSLog

public enum DimensionUnitValueParsingError: Error {
    case invalidValueString(String)
}

public enum DimensionUnit: String, UnitType, CaseIterable {
    public static let `default`: Self = .px

    case px
    case rem

    public static func decode(_ decoder: any Decoder) throws -> TokenMeasurement<DimensionUnit>? {
        let singleValueContainer = try decoder.singleValueContainer()
        let stringValue = try? singleValueContainer.decode(String.self)
        let doubleValue = try? singleValueContainer.decode(Double.self)

        switch (stringValue, doubleValue) {
        case (_, .some(let doubleValue)):
            return TokenMeasurement(value: doubleValue, unit: DimensionUnit.default)
        case (.some(let stringValue), .none):
            return try TokenMeasurement(stringValue: stringValue)
        case (_, _):
            return nil
        }
    }
}

extension TokenMeasurement where T == DimensionUnit {
    public init(stringValue: String) throws {
        var stringValue = stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let parsedUnit = DimensionUnit.allCases.first(where: {
            stringValue.hasSuffix($0.rawValue)
        })
        if let parsedUnit {
            stringValue = stringValue.replacingOccurrences(of: parsedUnit.rawValue, with: "")
        } else {
            os_log(
                .debug,
                "Unit format is unsupported or not specified. Defaulting to '%@' for value: '%@'",
                DimensionUnit.default.rawValue,
                stringValue
            )
        }

        guard let doubleValue = Double(stringValue) else {
            throw DimensionUnitValueParsingError.invalidValueString(stringValue)
        }

        self.init(value: doubleValue, unit: parsedUnit ?? .default)
    }

    public static func value(_ value: Double) -> Self {
        self.init(value: value, unit: .default)
    }
}
