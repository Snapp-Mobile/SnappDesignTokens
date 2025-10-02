//
//  CombineProcessorTests.swift
//
//  Created by Oleksii Kolomiiets on 9/18/25.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct CombineProcessorTests {
    @Test(arguments: [
        (
            """
            {
                "base": {
                    "color1": { "$value": "#FF0000", "$type": "color" },
                    "color2": { "$value": "{base.color1}" },
                    "space1": { "$value": "2", "$type": "dimension" }
                },
                "theme": {
                    "color1": { "$value": "{base.color1}" },
                    "color2": { "$value": "{theme.color1}" },
                    "space1": { "$value": "{base.space1}" }
                }
            }
            """,
            Token.group([
                "base.color1": .value(.color(.red)),
                "base.color2": .value(.color(.red)),
                "base.space1": .value(.dimension(.constant(.value(2)))),
                "theme.color1": .value(.color(.red)),
                "theme.color2": .value(.color(.red)),
                "theme.space1": .value(.dimension(.constant(.value(2)))),
            ])
        )
    ])
    func combinedProcessorsTest(json: String, expectedToken: Token) async throws {
        let token: Token = try json.decode()

        var processedToken = try await CombineProcessor.combine(
            .resolveAliases,
            .flatten()
        ).process(token)

        #expect(processedToken == expectedToken)

        processedToken =
            try await ResolveAliasesTokenProcessor
            .resolveAliases
            .combine(.flatten())
            .process(token)

        #expect(processedToken == expectedToken)
    }
}
