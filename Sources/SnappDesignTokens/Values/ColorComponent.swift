//
//  ColorComponent.swift
//
//  Created by Volodymyr Voiko on 13.05.2025.
//

/// Represents a single component value within a color.
///
/// Color components can either hold a numeric value or represent a missing/undefined
/// channel using the "none" keyword. Supports initialization from integer and floating-point
/// literals for convenience.
///
/// Example:
/// ```swift
/// // Numeric value
/// let red: ColorComponent = 1.0
/// let green: ColorComponent = 0
///
/// // None (missing channel)
/// let hue: ColorComponent = .none
///
/// // Array of components
/// let rgb: [ColorComponent] = [1.0, 0.5, 0]
/// ```
public enum ColorComponent: Equatable, Sendable, Codable {
    private static let noneKeyword = "none"

    /// Missing or undefined color channel.
    ///
    /// Encodes as the string `"none"`.
    case none

    /// Numeric component value.
    ///
    /// Interpretation depends on the color space and component position.
    case value(Double)

    /// Decodes a color component from numeric value or "none" string.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: ``DecodingError`` if value is neither numeric nor "none"
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let double = try container.decode(Double.self)
            self = .value(double)
        } catch {
            let string = try container.decode(String.self)
            guard string == Self.noneKeyword else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "Invalid value: \(string)"
                    )
                )
            }
            self = .none
        }
    }

    /// Encodes the component as numeric value or "none" string.
    ///
    /// - Parameter encoder: Encoder to write data to
    /// - Throws: Error if encoding fails
    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .none:
            try Self.noneKeyword.encode(to: encoder)
        case .value(let double):
            try double.encode(to: encoder)
        }
    }
}

extension ColorComponent: ExpressibleByFloatLiteral {
    /// Creates a component from a floating-point literal.
    ///
    /// Enables convenient initialization: `let red: ColorComponent = 1.0`
    ///
    /// - Parameter value: Floating-point value
    public init(floatLiteral value: Double) {
        self = .value(value)
    }
}

extension ColorComponent: ExpressibleByIntegerLiteral {
    /// Creates a component from an integer literal.
    ///
    /// Enables convenient initialization: `let green: ColorComponent = 0`
    ///
    /// - Parameter value: Integer value, converted to `Double`
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(floatLiteral: Double(value))
    }
}
