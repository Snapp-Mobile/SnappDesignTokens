//
//  TokenMappingTests.swift
//
//  Created by Volodymyr Voiko on 07.03.2025.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

struct TokenMappingTests {
    @Test(
        arguments: [
            (
                .group([
                    "base": .group([
                        "color": .value(.color(.red))
                    ]),
                    "theme": .group([
                        "light": .group([
                            "color": .value(.color(.red))
                        ]),
                        "dark": .group([
                            "color": .value(.color(.reddish))
                        ]),
                    ]),
                ]),
                .group([
                    "base": .group([
                        "color": .value(.color(.reddish))
                    ]),
                    "theme": .group([
                        "light": .group([
                            "color": .value(.color(.reddish))
                        ]),
                        "dark": .group([
                            "color": .value(.color(.red))
                        ]),
                    ]),
                ])
            )
        ] as [(Token, Token)]
    )
    func testMapping(
        input: Token,
        expectedOutput: Token
    ) async throws {
        let output = input.map { element in
            switch element {
            case .value(.color(.red)):
                .value(.color(.reddish))
            case .value(.color(.reddish)):
                .value(.color(.red))
            default:
                element
            }
        }

        #expect(output == expectedOutput)
    }
}
