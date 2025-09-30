//
//  TokenMeasurement.swift
//
//  Created by Volodymyr Voiko on 31.03.2025.
//

import Foundation

/// Represents a numeric value with an associated unit of measurement.
///
/// Generic structure used for DTCG token types that combine numeric values with units.
/// The unit type must conform to ``UnitType``, which enables specialized decoding for
/// formats like `"16px"` or bare numbers with default units.
///
/// Used by:
/// - ``DimensionConstant`` (``DimensionUnit``: px, rem)
/// - ``DurationValue`` (``DurationUnit``: s, ms)
///
/// Example:
/// ```swift
/// // Dimension measurement
/// let spacing = TokenMeasurement(value: 16, unit: DimensionUnit.px)
///
/// // Duration measurement
/// let delay = TokenMeasurement(value: 300, unit: DurationUnit.millisecond)
/// ```
public struct TokenMeasurement<T>: Codable, Equatable, Sendable
where T: UnitType {
    /// Numeric value of the measurement.
    public let value: Double

    /// Unit of measurement.
    public let unit: T

    enum CodingKeys: CodingKey {
        case value
        case unit
    }

    /// Creates a measurement with the specified value and unit.
    ///
    /// - Parameters:
    ///   - value: Numeric value
    ///   - unit: Unit of measurement
    public init(value: Double, unit: T) {
        self.value = value
        self.unit = unit
    }

    /// Decodes a measurement using custom or standard decoding.
    ///
    /// First attempts custom decoding via ``UnitType/decode(_:)`` to support specialized
    /// formats (e.g., `"16px"` for dimensions). Falls back to standard object format
    /// with separate `value` and `unit` properties.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: ``DecodingError`` if decoding fails
    public init(from decoder: any Decoder) throws {
        if let decoded = try T.decode(decoder) {
            self = decoded
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.value = try container.decode(Double.self, forKey: .value)
            self.unit = try container.decode(T.self, forKey: .unit)
        }
    }

    /// Encodes the measurement using the encoder's configuration.
    ///
    /// - Parameter encoder: Encoder to write data to
    /// - Throws: Error if encoding fails
    public func encode(to encoder: any Encoder) throws {
        try self.encode(
            to: encoder,
            configuration: encoder.tokenEncodingConfiguration
                .tokenValueEncodingConfiguration?.measurementEncodingConfiguration
                ?? .default
        )
    }

    /// Encodes the measurement with the specified configuration.
    ///
    /// - Parameters:
    ///   - encoder: Encoder to write data to
    ///   - configuration: Encoding format (`.default` for object, `.value` for string/number)
    /// - Throws: Error if encoding fails
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
