//
//  ArithmeticalExpressionEvaluator.swift
//
//  Created by Oleksii Kolomiiets on 11.03.2025.
//

import Foundation

/// Evaluates dimension formulas using custom arithmetic parser.
///
/// Alternative to NSExpression-based evaluation. Converts dimension expressions
/// to formulas in base unit, then evaluates using ``ArithmeticalExpressionManager``.
public struct ArithmeticalExpressionEvaluator: DimensionValueEvaluator {
    /// Base unit for formula evaluation.
    let baseUnit: DimensionUnit

    /// Converter for dimension unit transformations.
    let converter: DimensionValueConverter

    /// Creates an arithmetic expression evaluator with the specified configuration.
    ///
    /// - Parameters:
    ///   - baseUnit: Base unit for evaluation, defaults to `.px`
    ///   - converter: Unit converter, defaults to `.default`
    init(
        baseUnit: DimensionUnit = .px,
        converter: DimensionValueConverter = .default
    ) {
        self.baseUnit = baseUnit
        self.converter = converter
    }

    /// Evaluates a dimension expression to a constant value.
    ///
    /// Converts expression to formula in base unit, then evaluates using arithmetic parser.
    /// Result is returned in the configured base unit.
    ///
    /// - Parameter expression: Dimension expression to evaluate
    /// - Returns: Evaluated dimension constant in base unit
    /// - Throws: Error if formula conversion or evaluation fails
    public func evaluate(_ expression: DimensionExpression) throws -> DimensionConstant {
        let formula = try expression.formula(converter: converter, baseUnit: baseUnit)
        let manager = ArithmeticalExpressionManager<Double>(formula: formula)
        let evaluatedValue = try manager.evaluate()
        return .init(value: evaluatedValue, unit: baseUnit)
    }
}
