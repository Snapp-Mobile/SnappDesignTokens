//
//  DimensionValueEvaluationProcessor.swift
//
//  Created by Volodymyr Voiko on 10.03.2025.
//

import Foundation

public struct DimensionValueEvaluationProcessor: TokenProcessor {
    public let evaluator: DimensionValueEvaluator

    public init(evaluator: DimensionValueEvaluator) {
        self.evaluator = evaluator
    }

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
    public static var arithmeticalEvaluation: Self {
        DimensionValueEvaluationProcessor(
            evaluator: ArithmeticalExpressionEvaluator(
                baseUnit: .px,
                converter: .default
            )
        )
    }

    public static var expressionsEvaluation: Self {
        DimensionValueEvaluationProcessor(
            evaluator: NSExpressionDimensionEvaluator(
                baseUnit: .px,
                converter: .default
            )
        )
    }
}
