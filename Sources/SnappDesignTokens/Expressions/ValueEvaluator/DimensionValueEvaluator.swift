//
//  DimensionValueEvaluator.swift
//
//  Created by Volodymyr Voiko on 10.03.2025.
//

/// A protocol defining methods for evaluating dimensional formulas and expressions.
///
/// This protocol is responsible for evaluating string formulas and dimension expressions,
/// converting them into concrete dimension values with appropriate units.
public protocol DimensionValueEvaluator: Sendable {
    /// Evaluates a dimension expression and returns a value with its unit.
    ///
    /// - Parameter expression: The dimension expression to evaluate
    /// - Returns: A dimension value with its associated unit
    /// - Throws: An error if the expression is invalid or cannot be evaluated
    func evaluate(_ expression: DimensionExpression) throws -> DimensionConstant
}
