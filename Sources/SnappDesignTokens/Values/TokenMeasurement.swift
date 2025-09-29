//
//  TokenMeasurement.swift
//
//  Created by Volodymyr Voiko on 31.03.2025.
//

import Foundation

public struct TokenMeasurement<T>: Codable, Equatable, Sendable
where T: UnitType {
    public let value: Double
    public let unit: T

    enum CodingKeys: CodingKey {
        case value
        case unit
    }

    public init(value: Double, unit: T) {
        self.value = value
        self.unit = unit
    }

    public init(from decoder: any Decoder) throws {
        if let decoded = try T.decode(decoder) {
            self = decoded
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.value = try container.decode(Double.self, forKey: .value)
            self.unit = try container.decode(T.self, forKey: .unit)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        try self.encode(
            to: encoder,
            configuration: encoder.tokenEncodingConfiguration
                .tokenValueEncodingConfiguration?.measurementEncodingConfiguration
                ?? .default
        )
    }

    public func encode(
        to encoder: any Encoder,
        configuration: MeasurementValueEncodingConfiguration
    ) throws {
        switch configuration {
        case .default:
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.value, forKey: .value)
            try container.encode(self.unit, forKey: .unit)

        case let .value(withUnit):
            if withUnit {
                try "\(self.value)\(self.unit)".encode(to: encoder)
            } else {
                // encodes number(e.g 12) not string(e.g. "12")
                try self.value.encode(to: encoder)
            }
        }
    }
}
