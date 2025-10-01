//
//  DimensionValueEvaluationProcessor.swift
//
//  Created by Volodymyr Voiko on 10.03.2025.
//

import Foundation

/// Processor that evaluates dimension expressions to constant values.
///
/// Traverses token tree converting dimension expression tokens (e.g., `16 * 1.5`)
/// to constant dimension values using pluggable ``DimensionValueEvaluator``
/// implementations. Supports arithmetic and NSExpression-based evaluation.
///
/// Example:
/// ```swift
/// // Token with expression: { "spacing": "16px * 1.5" }
///
/// let processor: TokenProcessor = .arithmeticalEvaluation
/// let evaluated = try await processor.process(token)
/// // Result: { "spacing": "24px" }
/// ```
public struct DimensionValueEvaluationProcessor: TokenProcessor {
    /// Evaluator for computing dimension expression results as ``DimensionValueEvaluator``.
    public let evaluator: DimensionValueEvaluator

    /// Creates a dimension value evaluation processor.
    ///
    /// - Parameter evaluator: Evaluator implementation for expression computation
    public init(evaluator: DimensionValueEvaluator) {
        self.evaluator = evaluator
    }

    /// Evaluates all dimension expressions in token tree.
    ///
    /// Replaces dimension expression tokens with constant dimension values.
    /// Non-expression tokens pass through unchanged.
    ///
    /// - Parameter token: Token tree to process
    /// - Returns: Token tree with expressions evaluated to constants
    /// - Throws: Evaluation error if expression is invalid or cannot be computed
    public func process(_ token: Token) async throws -> Token {
        try token.map { element in
            guard
                case .value(.dimension(.expression(let expression))) = element
            else {
                return element
            }

            let evaluatedValue = try evaluator.evaluate(expression)
            return .value(.dimension(.constant(evaluatedValue)))
        }
    }
}

extension TokenProcessor
where Self == DimensionValueEvaluationProcessor {
    /// Arithmetical expression evaluator with px base unit (basic arithmetic only).
    ///
    /// Uses ``ArithmeticalExpressionEvaluator`` supporting `+`, `-`, `*`, `/`
    /// operators with parentheses.
    public static var arithmeticalEvaluation: Self {
        DimensionValueEvaluationProcessor(
            evaluator: ArithmeticalExpressionEvaluator(
                baseUnit: .px,
                converter: .default
            )
        )
    }

    /// NSExpression-based evaluator with px base unit (full expression support).
    ///
    /// Uses ``NSExpressionDimensionEvaluator`` leveraging Foundation's
    /// `NSExpression` for advanced mathematical operations.
    public static var expressionsEvaluation: Self {
        DimensionValueEvaluationProcessor(
            evaluator: NSExpressionDimensionEvaluator(
                baseUnit: .px,
                converter: .default
            )
        )
    }
}
