//
//  CompositeTokenAliasesResolutionTests.swift
//
//  Created by Volodymyr Voiko on 26.03.2025.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

struct CompositeTokenAliasesResolutionTests {
    @Test
    func testAliasesResolution() throws {
        let token: Token = .group([
            "dimension": .group([
                "fontSize": .value(
                    .dimension(.constant(.init(value: 16, unit: .px)))
                )
            ]),
            "typography": .group([
                "body": .value(
                    .typography(
                        .init(
                            fontFamily: .value("Helvetica"),
                            fontSize: .alias(
                                TokenPath("dimension", "fontSize")
                            ),
                            fontWeight: .value(.bold),
                            letterSpacing: .value(
                                .constant(.init(value: 0.1, unit: .px))
                            ),
                            lineHeight: .value(1.2)
                        )
                    )
                )
            ]),
        ])

        var resolved = token
        try resolved.resolveAliases()

        let expectedToken: Token = .group([
            "dimension": .group([
                "fontSize": .value(
                    .dimension(.constant(.init(value: 16, unit: .px)))
                )
            ]),
            "typography": .group([
                "body": .value(
                    .typography(
                        .init(
                            fontFamily: .value("Helvetica"),
                            fontSize: .value(
                                .constant(.init(value: 16, unit: .px))
                            ),
                            fontWeight: .value(.bold),
                            letterSpacing: .value(
                                .constant(.init(value: 0.1, unit: .px))
                            ),
                            lineHeight: .value(1.2)
                        )
                    )
                )
            ]),
        ])

        #expect(resolved == expectedToken)
    }

    @Test
    func testAliasesResolutionTypeMismatchError() throws {
        let token: Token = .group([
            "dimension": .group([
                "fontSize": .value(.color(.red))
            ]),
            "typography": .group([
                "body": .value(
                    .typography(
                        .init(
                            fontFamily: .value("Helvetica"),
                            fontSize: .alias(
                                TokenPath("dimension", "fontSize")
                            ),
                            fontWeight: .value(.bold),
                            letterSpacing: .value(
                                .constant(.init(value: 0.1, unit: .px))
                            ),
                            lineHeight: .value(1.2)
                        )
                    )
                )
            ]),
        ])

        var resolved = token

        #expect(
            throws: CompositeTokenValueAliasResolutionError.typeMismatch(
                path: TokenPath("dimension", "fontSize")
            )
        ) {
            try resolved.resolveAliases()
        }
    }
}
