//
//  DimensionValueEvaluator.swift
//
//  Created by Volodymyr Voiko on 10.03.2025.
//

/// Protocol for evaluating dimension expressions to constant values.
///
/// Defines strategy for parsing and computing mathematical expressions in design
/// tokens. Implementations handle operator precedence, unit conversion, and
/// error handling for invalid expressions.
///
/// Built-in implementations:
/// - ``ArithmeticalExpressionEvaluator`` - Basic arithmetic (`+`, `-`, `*`, `/`)
/// - ``NSExpressionDimensionEvaluator`` - Advanced math via `NSExpression`
///
/// ### Example
/// ```swift
/// let evaluator = ArithmeticalExpressionEvaluator(baseUnit: .px, converter: .default)
/// let expression = DimensionExpression(elements: [...])
/// let result = try evaluator.evaluate(expression)  // DimensionConstant(value: 24, unit: .px)
/// ```
public protocol DimensionValueEvaluator: Sendable {
    /// Evaluates dimension expression to constant value.
    ///
    /// Parses expression elements (values, operators, parentheses) and computes
    /// final result with appropriate unit.
    ///
    /// - Parameter expression: Dimension expression to evaluate
    /// - Returns: Evaluated dimension constant with unit
    /// - Throws: ``DimensionValueEvaluationError`` if expression is invalid or evaluation fails
    func evaluate(_ expression: DimensionExpression) throws -> DimensionConstant
}
