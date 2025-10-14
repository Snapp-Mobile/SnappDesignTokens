//
//  ResolveAliasesTokenProcessorTests.swift
//
//  Created by Volodymyr Voiko on 04.03.2025.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct ResolveAliasesTokenProcessorTests {
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
                "base": .group([
                    "color1": .value(.color(.red)),
                    "color2": .value(.color(.red)),
                    "space1": .value(.dimension(.constant(.value(2)))),
                ]),
                "theme": .group([
                    "color1": .value(.color(.red)),
                    "color2": .value(.color(.red)),
                    "space1": .value(.dimension(.constant(.value(2)))),
                ]),
            ])
        )
    ])
    func resolveAliases(json: String, expectedToken: Token) async throws {
        let token: Token = try json.decode()
        let resolvedAliasesToken =
            try await ResolveAliasesTokenProcessor
            .resolveAliases
            .process(token)
        #expect(resolvedAliasesToken == expectedToken)
    }
}
