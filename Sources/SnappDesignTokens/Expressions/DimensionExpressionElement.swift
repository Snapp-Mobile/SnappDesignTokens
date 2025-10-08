//
//  DimensionExpressionElement.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

/// Element of a dimension expression.
///
/// Represents individual components in mathematical dimension expressions:
/// operations, dimension values, or token alias references.
///
/// ### Example
/// ```swift
/// let elements: [DimensionExpressionElement] = [
///     .value(16, .px),           // Dimension value
///     .operation(.multiply),     // Operator
///     .alias(TokenPath("spacing.base"))  // Token reference
/// ]
/// ```
public enum DimensionExpressionElement: Equatable, Sendable, RawRepresentable {
    /// Arithmetic operation or parenthesis.
    case operation(ArithmeticOperation)

    /// Token alias reference.
    case alias(TokenPath)

    /// Dimension constant value.
    case value(DimensionConstant)

    /// String representation of element.
    public var rawValue: String {
        switch self {
        case .operation(let operation):
            return operation.rawValue
        case .alias(let path):
            return path.rawValue
        case .value(let dimension):
            return String(describing: dimension.value) + dimension.unit.rawValue
        }
    }

    /// Creates element by parsing string value.
    ///
    /// Attempts to parse as operation, alias, or dimension constant.
    ///
    /// - Parameter stringValue: String to parse
    /// - Throws: ``DimensionExpressionElementParseError`` if format is invalid
    public init(from stringValue: String) throws {
        if let operation = ArithmeticOperation(rawValue: stringValue) {
            self = .operation(operation)
        } else if let path = try? TokenPath(from: stringValue) {
            self = .alias(path)
        } else if let value = try? DimensionConstant(stringValue: stringValue) {
            self = .value(value)
        } else {
            throw DimensionExpressionElementParseError.invalidFormat
        }
    }

    /// Creates element from raw string value.
    ///
    /// Failable initializer returning `nil` for invalid formats.
    ///
    /// - Parameter rawValue: String to parse
    public init?(rawValue: String) {
        try? self.init(from: rawValue)
    }
}

extension DimensionExpressionElement {
    /// Creates dimension value element.
    ///
    /// - Parameters:
    ///   - value: Numeric value
    ///   - unit: Dimension unit (default: `.px`)
    /// - Returns: Value element with dimension constant
    public static func value(_ value: Double, _ unit: DimensionUnit = .px) -> Self {
        .value(DimensionConstant(value: value, unit: unit))
    }

    /// Addition operation element.
    public static let add: Self = .operation(.add)

    /// Multiplication operation element.
    public static let multiply: Self = .operation(.multiply)

    /// Division operation element.
    public static let divide: Self = .operation(.divide)

    /// Subtraction operation element.
    public static let subtract: Self = .operation(.subtract)
}
