//
//  NSExpressionDimensionEvaluator.swift
//
//  Created by Volodymyr Voiko on 10.03.2025.
//

import Foundation

/// Type alias for the default NSExpression-based dimension evaluator.
public typealias NSExpressionDimensionEvaluator = DefaultNSExpressionDimensionEvaluator<RegularExpression>

/// Evaluates dimension formulas using Foundation's NSExpression.
///
/// Calculates numeric values from mathematical expressions in dimension tokens.
/// Converts all dimension values to a base unit before evaluation, then evaluates
/// the formula using NSExpression.
public struct DefaultNSExpressionDimensionEvaluator<T: RegularExpressionProtocol>: DimensionValueEvaluator {
    /// Base unit for formula evaluation.
    let baseUnit: DimensionUnit

    /// Converter for dimension unit transformations.
    let converter: DimensionValueConverter

    /// Regular expression validator for formula syntax.
    var regularExpression: T

    /// Creates a dimension evaluator with the specified configuration.
    ///
    /// - Parameters:
    ///   - baseUnit: Base unit for evaluation, defaults to `.px`
    ///   - converter: Unit converter, defaults to `.default`
    ///   - regularExpression: Formula validator, defaults to `RegularExpression()`
    public init(
        baseUnit: DimensionUnit = .px,
        converter: DimensionValueConverter = .default,
        regularExpression: T = RegularExpression()
    ) {
        self.baseUnit = baseUnit
        self.converter = converter
        self.regularExpression = regularExpression
    }

    /// Evaluates a dimension expression to a constant value.
    ///
    /// Converts expression to formula in base unit, validates syntax, and evaluates
    /// using NSExpression. Result is always returned in pixels.
    ///
    /// - Parameter expression: Dimension expression to evaluate
    /// - Returns: Evaluated dimension constant in pixels
    /// - Throws: ``DimensionValueEvaluationError`` if formula is invalid or evaluation fails
    public func evaluate(
        _ expression: DimensionExpression
    ) throws -> DimensionConstant {
        let formula = try expression.formula(
            converter: converter,
            baseUnit: baseUnit
        )

        // Evaluate the value of the expression
        let value: Double = try evaluatedValue(formula)

        // result is in .px always
        return DimensionConstant(value: value, unit: .px)
    }

    private func evaluatedValue(
        _ formula: String
    ) throws(DimensionValueEvaluationError) -> Double {
        // Validate the formula
        try validate(formula)

        let expression = NSExpression(format: formula)
        let value = expression.expressionValue(with: nil, context: nil)

        guard let value, let double = value as? Double else {
            throw .invalidFormula(formula)
        }

        let evaluatedValue: Double = double.roundedToFourDecimalPlaces()

        return evaluatedValue
    }

    private func validate(
        _ formula: String
    ) throws(DimensionValueEvaluationError) {
        let expressionValue = NSExpressionFormulaSyntax(formula: formula, regularExpression: regularExpression)
        try expressionValue.isValidFormat()
    }
}
