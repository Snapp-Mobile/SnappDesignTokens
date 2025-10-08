//
//  DimensionValue.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation
import OSLog

/// Represents a dimension token value for UI measurements.
///
/// DTCG primitive token type representing amounts of distance in a single dimension,
/// including width, height, position, spacing, radius, or thickness. Supports both
/// constant values and calculated expressions.
///
/// Per DTCG specification, dimensions must have a numeric value and unit (px or rem).
///
/// ### Example
/// ```swift
/// // Constant dimension
/// let spacing = DimensionValue(value: 16, unit: .px)
/// let padding = DimensionValue.constant(.init(value: 2, unit: .rem))
///
/// // Expression (calculated)
/// let combined = DimensionValue.expression(
///     .value(.init(value: 10, unit: .px)),
///     .operation(.add),
///     .value(.init(value: 1, unit: .rem))
/// )
/// ```
public enum DimensionValue: Codable, Equatable, Sendable {
    /// Creates an expression dimension from variadic elements.
    ///
    /// Convenience method for building ``DimensionExpression`` from elements.
    ///
    /// - Parameter elements: Expression elements (values and operations)
    /// - Returns: Dimension value with expression case
    public static func expression(_ elements: DimensionExpressionElement...) -> Self {
        .expression(DimensionExpression(elements: elements))
    }

    /// Calculated dimension expression (e.g., `"10px + 1rem"`).
    case expression(DimensionExpression)

    /// Constant dimension value with unit.
    case constant(DimensionConstant)

    /// Decodes a dimension as constant or expression.
    ///
    /// Attempts to decode as ``DimensionConstant`` first, falling back to ``DimensionExpression``.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: `DecodingError` if neither format succeeds
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let constantValue = try? container.decode(DimensionConstant.self)

        switch constantValue {
        case .some(let constantValue):
            self = .constant(constantValue)
        case .none:
            let expression = try container.decode(DimensionExpression.self)
            self = .expression(expression)
        }
    }

    /// Creates a constant dimension with the specified value and unit.
    ///
    /// - Parameters:
    ///   - value: Numeric value
    ///   - unit: Unit of measurement (`.px` or `.rem`)
    public init(value: Double, unit: DimensionUnit) {
        self = .constant(DimensionConstant(value: value, unit: unit))
    }

    /// Encodes the dimension value.
    ///
    /// - Parameter encoder: Encoder to write data to
    /// - Throws: Error if encoding fails
    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .expression(let expression):
            try expression.encode(to: encoder)
        case .constant(let value):
            try value.encode(to: encoder)
        }
    }
}
