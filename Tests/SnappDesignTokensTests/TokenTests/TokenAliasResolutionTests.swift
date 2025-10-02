//
//  TokenAliasResolutionTests.swift
//
//  Created by Volodymyr Voiko on 06.03.2025.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

struct TokenAliasResolutionTests {
    let root: Token = .group(
        [
            "base": .group(
                [
                    "color1": .value(.color(.red)),
                    "color2": .alias(TokenPath(["base", "color1"])),
                    "circular": .alias(TokenPath(["base", "circular"])),
                    "dimension1": .value(
                        .dimension(.constant(.init(value: 1, unit: .px)))),
                ]
            ),
            "color": .alias(TokenPath(["base", "color2"])),
            "invalidValue": .alias(TokenPath(["base"])),
            "circular": .alias(TokenPath(["base", "circular"])),
            "expression": .value(
                .dimension(
                    .expression(
                        .value(.init(value: 2, unit: .px)),
                        .operation(.multiply),
                        .alias(TokenPath(["base", "dimension1"]))
                    )
                )
            ),
            "invalidExpressionValue": .value(
                .dimension(
                    .expression(
                        .value(.init(value: 2, unit: .px)),
                        .operation(.multiply),
                        .alias(TokenPath(["base", "color1"]))
                    )
                )
            )
        ]
    )

    @Test(
        arguments: [
            (["base", "color2"], .value(.color(.red))),
            (["color"], .value(.color(.red))),
            (
                ["expression"],
                .value(
                    .dimension(
                        .expression(
                            .value(.init(value: 2, unit: .px)),
                            .operation(.multiply),
                            .value(.init(value: 1, unit: .px))
                        )
                    )
                )
            ),
        ] as [([String], Token)]
    )
    func testResolveAliasesSuccessfully(
        rawPath: [String],
        expectedValue: Token
    ) throws {
        let path = TokenPath(rawPath)
        let resolvedValue = try root.resolveAlias(path)
        #expect(resolvedValue == expectedValue)
    }

    @Test(
        arguments: [
            ([], .emptyPath),
            (["invalid"], .invalidReference("invalid")),
            (["invalidValue"], .invalidValueForReference),
            (["circular"], .circularReference),
            (["invalidExpressionValue"], .invalidValueForReference)
        ] as [([String], TokenResolutionError)]
    )
    func testResolveAliasesFailing(
        rawPath: [String],
        expectedError: TokenResolutionError
    ) throws {
        let path = TokenPath(rawPath)
        #expect(throws: expectedError) {
            let _ = try root.resolveAlias(path)
        }
    }

    @Test
    func testResolvingInvalidRoot() {
        let root = Token.value(.color(.red))
        let path = TokenPath(["some", "key"])
        #expect(throws: TokenResolutionError.invalidRoot) {
            let _ = try root.resolveAlias(path)
        }
    }
}
