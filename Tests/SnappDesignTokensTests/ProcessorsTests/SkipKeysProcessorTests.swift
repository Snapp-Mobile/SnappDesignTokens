//
//  SkipKeysProcessorTests.swift
//
//  Created by Oleksii Kolomiiets on 9/18/25.
//

import Testing

@testable import SnappDesignTokens

@Suite
struct SkipKeysProcessorTests {
    @Test(arguments: [
        (
            """
            {
                "base": {
                    "color1": { "$value": "#FF0000", "$type": "color" },
                    "space1": { "$value": "2", "$type": "dimension" }
                },
                "theme": {
                    "color1": { "$value": "#FF0000", "$type": "color" },
                    "space1": { "$value": "2", "$type": "dimension" }
                }
            }
            """,
            Token.group([
                "theme": .group([
                    "color1": .value(.color(.red)),
                    "space1": .value(.dimension(.constant(.value(2)))),
                ])
            ])
        )
    ])
    func skipKeysProcessorTests(json: String, expectedToken: Token) async throws {
        let token: Token = try json.decode()
        let skippedKeysToken = try await SkipKeysProcessor.skipKeys([
            "base"
        ]).process(token)
        #expect(skippedKeysToken == expectedToken)
    }
}
