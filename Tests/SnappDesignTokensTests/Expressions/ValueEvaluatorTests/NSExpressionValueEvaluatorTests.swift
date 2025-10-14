//
//  NSExpressionValueEvaluatorTests.swift
//
//  Created by Oleksii Kolomiiets on 10.03.2025.
//

import Foundation
import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct NSExpressionValueEvaluatorTests {
    let evaluator: NSExpressionDimensionEvaluator

    init() {
        evaluator = NSExpressionDimensionEvaluator()
    }

    @Test(
        arguments: [
            (
                [
                    DimensionExpressionElement.value(4, .px),
                    .multiply,
                    .value(5, .px),
                ],
                20, DimensionUnit.px
            ),
            (
                [.value(2, .rem), .add, .value(5)],
                37, .px
            ),
            (
                [.value(4), .add, .value(5)],
                9, .px
            ),
            (
                [.value(2.5, .rem), .add, .value(1.5, .rem)],
                64, .px
            ),
            (
                [.value(2, .rem), .subtract, .value(1)],
                31, .px
            ),
            (
                [.value(20, .rem), .divide, .value(10)],
                32, .px
            ),
            (
                [.value(-3), .multiply, .multiply, .value(2)],  // NSExpression consumes ‘**’ as ‘pow’
                9, .px
            ),
        ]
    )
    func testSuccessEvaluation(
        elements: [DimensionExpressionElement],
        expectedValue: Double,
        expectedUnit: DimensionUnit
    )
        async throws
    {
        let expression = DimensionExpression(elements: elements)
        let valueAndUnit = try evaluator.evaluate(expression)
        let expectedValueAndUnit = DimensionConstant(value: expectedValue, unit: expectedUnit)
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
            [DimensionExpressionElement.value(1), .add, .add, .value(2)],
            [.value(1), .multiply, .add, .value(2)],
        ]
    )
    func testInvalidFormulaEvaluation(elements: [DimensionExpressionElement]) async throws {
        let expression = DimensionExpression(elements: elements)
        let formulaWithoutUnits =
            elements
            .map { expression in
                return expression.rawValue
                    .replacingOccurrences(of: "px", with: "")
                    .replacingOccurrences(of: "rem", with: "")
            }
            .joined()
        let expectedError = DimensionValueEvaluationError.invalidFormula(formulaWithoutUnits)

        #expect(throws: expectedError) { _ = try evaluator.evaluate(expression) }
    }

    @Test(
        arguments: [
            [DimensionExpressionElement.value(1), .add, .add, .value(2)],
            [.value(1), .multiply, .add, .value(2)],
        ]
    )
    func testFailingNSRegularExpression(elements: [DimensionExpressionElement]) async throws {
        let expression = DimensionExpression(elements: elements)
        let evaluator = DefaultNSExpressionDimensionEvaluator(regularExpression: MockRegularExpression())
        let expectedFailure = MockRegularExpression.MockDimensionValueEvaluationError.mockError
        let expectedError = DimensionValueEvaluationError.regexCompilationFailure(expectedFailure)

        #expect(throws: expectedError) { _ = try evaluator.evaluate(expression) }
    }
}
