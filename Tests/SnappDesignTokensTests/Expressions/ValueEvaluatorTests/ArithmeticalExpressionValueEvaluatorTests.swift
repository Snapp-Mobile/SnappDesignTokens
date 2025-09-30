//
//  ArithmeticalExpressionValueEvaluatorTests.swift
//
//  Created by Oleksii Kolomiiets on 13.03.2025.
//

import Testing

@testable import SnappDesignTokens

@Suite
struct ArithmeticalExpressionValueEvaluatorTests {
    let evaluator: ArithmeticalExpressionEvaluator

    init() {
        evaluator = ArithmeticalExpressionEvaluator()
    }

    @Test(
        arguments: [
            ([DimensionExpressionElement.value(4, .px), .multiply, .value(5, .px)], 20),
            ([.value(2, .rem), .add, .value(5)], 37),
            ([.value(4), .add, .value(5)], 9),
            ([.value(2.5, .rem), .add, .value(1.5, .rem)], 64),
            ([.value(2, .rem), .subtract, .value(1)], 31),
            ([.value(20, .rem), .divide, .value(10)], 32),
            ([.value(1), .add, .add, .value(2)], 3),
            ([.value(1), .multiply, .add, .value(2)], 2),
            ([.value(1), .subtract, .add, .value(2)], -1),
        ]
    )
    func testSuccessEvaluation(elements: [DimensionExpressionElement], expectedValue: Double)
        async throws
    {
        let expression = DimensionExpression(elements: elements)
        let valueAndUnit = try evaluator.evaluate(expression)
        let expectedValueAndUnit = DimensionConstant(value: expectedValue, unit: .px)
        #expect(valueAndUnit == expectedValueAndUnit)
    }

    @Test(
        arguments: [
            [DimensionExpressionElement.alias(.init([])), .multiply, .value(5, .px)]
        ]
    )
    func testFailingEvaluation(elements: [DimensionExpressionElement]) async throws {
        let expression = DimensionExpression(elements: elements)
        let expectedError = DimensionValueEvaluationError.unresolvedAlias(path: TokenPath())

        #expect(throws: expectedError) { _ = try evaluator.evaluate(expression) }
    }

    @Test(
        arguments: [
            [DimensionExpressionElement.value(-3), .multiply, .divide, .value(2)],
            [.value(-3), .divide, .divide, .value(2)],
        ]
    )
    func testFormulaWithInvalidDivideCharacterEvaluation(elements: [DimensionExpressionElement]) async throws {
        let expression = DimensionExpression(elements: elements)
        let expectedError = DimensionValueEvaluationError.invalidCharacter("/", position: 5)

        #expect(throws: expectedError) { _ = try evaluator.evaluate(expression) }
    }

    @Test(
        arguments: [
            [DimensionExpressionElement.value(-3), .multiply, .multiply, .value(2)],
            [.value(-3), .divide, .multiply, .value(2)],
        ]
    )
    func testFormulaWithInvalidMultiplyCharacterEvaluation(elements: [DimensionExpressionElement]) async throws {
        let expression = DimensionExpression(elements: elements)
        let expectedError = DimensionValueEvaluationError.invalidCharacter("*", position: 5)

        #expect(throws: expectedError) { _ = try evaluator.evaluate(expression) }
    }
}
