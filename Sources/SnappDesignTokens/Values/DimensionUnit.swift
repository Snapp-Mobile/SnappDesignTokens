//
//  DimensionUnit.swift
//
//  Created by Volodymyr Voiko on 10.03.2025.
//

import Foundation
import OSLog

/// Error thrown when parsing an invalid dimension unit string.
public enum DimensionUnitValueParsingError: Error {
    /// String cannot be parsed as a valid numeric dimension value.
    case invalidValueString(String)
}

/// Units of measurement for dimension tokens.
///
/// DTCG dimension tokens support two standard units for representing UI distances.
/// Conforms to ``UnitType`` to enable specialized decoding of formats like `"16px"` or
/// bare numbers (defaulting to `.px`).
///
/// Example:
/// ```swift
/// let pixels = DimensionUnit.px
/// let rems = DimensionUnit.rem
/// ```
public enum DimensionUnit: String, UnitType, CaseIterable {
    /// Default unit when none is specified.
    public static let `default`: Self = .px

    /// Pixels - idealized pixel on the viewport.
    case px

    /// Rem - multiple of the system's default font size (typically 16px = 1rem).
    case rem

    /// Decodes a dimension measurement from string or numeric format.
    ///
    /// Supports multiple input formats:
    /// - Bare number: Defaults to `.px` (e.g., `16` → 16px)
    /// - String with unit: Parses value and unit (e.g., `"16px"`, `"2rem"`)
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Returns: Decoded ``TokenMeasurement`` or `nil` for standard decoding
    /// - Throws: ``DimensionUnitValueParsingError`` if string format is invalid
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
    /// Parses a dimension measurement from a string with optional unit suffix.
    ///
    /// Extracts numeric value and unit from formats like `"16px"`, `"2rem"`, or `"8"`.
    /// When unit is missing or unrecognized, defaults to `.px`.
    ///
    /// - Parameter stringValue: String to parse (e.g., `"16px"`, `"2rem"`)
    /// - Throws: ``DimensionUnitValueParsingError/invalidValueString(_:)`` if numeric part is invalid
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

    /// Creates a dimension measurement with the default unit (`.px`).
    ///
    /// - Parameter value: Numeric value in pixels
    /// - Returns: Measurement with `.px` unit
    public static func value(_ value: Double) -> Self {
        self.init(value: value, unit: .default)
    }
}
