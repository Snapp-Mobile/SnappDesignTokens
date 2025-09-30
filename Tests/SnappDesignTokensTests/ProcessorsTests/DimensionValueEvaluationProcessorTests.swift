//
//  DimensionValueEvaluationProcessorTests.swift
//
//  Created by Oleksii Kolomiiets on 9/18/25.
//

import Testing

@testable import SnappDesignTokens

@Suite
struct DimensionValueEvaluationProcessorTests {
    @Test(arguments: [
        (
            """
            {
                "space1": { "$value": "2*2", "$type": "dimension" },
                "space2": { "$value": "2", "$type": "dimension" }
            }
            """,
            Token.group([
                "space1": .value(.dimension(.constant(.value(4)))),
                "space2": .value(.dimension(.constant(.value(2)))),
            ])
        )
    ])
    func dimensionValueEvaluationTest(json: String, expectedToken: Token) async throws {
        let token: Token = try json.decode()
        var evaluatedToken =
            try await DimensionValueEvaluationProcessor
            .arithmeticalEvaluation
            .process(token)

        #expect(evaluatedToken == expectedToken)

        evaluatedToken =
            try await DimensionValueEvaluationProcessor
            .expressionsEvaluation
            .process(token)

        #expect(evaluatedToken == expectedToken)
    }
}
