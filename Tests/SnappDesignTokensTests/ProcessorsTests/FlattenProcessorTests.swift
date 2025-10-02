//
//  FlattenProcessorTests.swift
//
//  Created by Oleksii Kolomiiets on 9/18/25.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct FlattenProcessorTests {
    @Test(arguments: [
        (
            """
            {
                "color0": { "$value": "#FF0000", "$type": "color" },
                "base": {
                    "color1": { "$value": "#FF0000", "$type": "color" },
                    "space1": { "$value": "2", "$type": "dimension" }
                }
            }
            """,
            Token.group([
                "color0": .value(.color(.red)),
                "base.color1": .value(.color(.red)),
                "base.space1": .value(.dimension(.constant(.value(2)))),
            ])
        )
    ])
    func flattenDotSeparatedTest(json: String, expectedToken: Token) async throws {
        let token: Token = try json.decode()
        var flattenedToken = try await FlattenProcessor.flattenDotSeparated.process(token)
        #expect(flattenedToken == expectedToken)

        flattenedToken = try await FlattenProcessor.flatten().process(token)
        #expect(flattenedToken == expectedToken)
    }

    @Test(arguments: [
        (
            """
            {
                "color0": { "$value": "#FF0000", "$type": "color" },
                "base": {
                    "color1": { "$value": "#FF0000", "$type": "color" },
                    "space1": { "$value": "2", "$type": "dimension" }
                }
            }
            """,
            Token.group([
                "color0": .value(.color(.red)),
                "base_color1": .value(.color(.red)),
                "base_space1": .value(.dimension(.constant(.value(2)))),
            ])
        )
    ])
    func flattenConvertToSnakeCaseTest(json: String, expectedToken: Token) async throws {
        let token: Token = try json.decode()
        let flattenedToken =
            try await FlattenProcessor
            .flatten(pathConversionStrategy: .convertToSnakeCase)
            .process(token)
        #expect(flattenedToken == expectedToken)
    }

    @Test(arguments: [
        (
            """
            {
                "color0": { "$value": "#FF0000", "$type": "color" },
                "base": {
                    "color1": { "$value": "#FF0000", "$type": "color" },
                    "space1": { "$value": "2", "$type": "dimension" }
                }
            }
            """,
            Token.group([
                "color0": .value(.color(.red)),
                "baseColor1": .value(.color(.red)),
                "baseSpace1": .value(.dimension(.constant(.value(2)))),
            ])
        )
    ])
    func flattenConvertToCameCaseTest(json: String, expectedToken: Token) async throws {
        let token: Token = try json.decode()
        let flattenedToken =
            try await FlattenProcessor
            .flatten(pathConversionStrategy: .convertToCamelCase)
            .process(token)
        #expect(flattenedToken == expectedToken)
    }

    // TODO: Add tests for `FlatteningDepth.limitWhere((TokenGroup) -> Bool)` use case
}
