//
//  GradientValueCodableTests.swift
//
//  Created by Oleksii Kolomiiets on 31.03.2025.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct GradientValueCodableTests {
    @Test(
        .dtcgEncoder(
            with: .init(tokenValue: .init(color: .hex)),
            outputFormatting: [.sortedKeys, .prettyPrinted]
        )
    )
    func testDecodingEncodingSimpleGradient() async throws {
        let json =
            """
            {
              "$type" : "gradient",
              "$value" : [
                {
                  "color" : "#0000FF",
                  "position" : 0
                },
                {
                  "color" : "#FF0000",
                  "position" : 1
                }
              ]
            }
            """
        let expectedToken: Token = .value(
            .gradient(
                .stops(
                    .stop(.value(.blue), at: .value(0)),
                    .stop(.value(.red), at: .value(1))
                )
            )
        )

        let tokenValue: Token = try json.decode()
        #expect(tokenValue == expectedToken)

        let encodedJSON: String = try .encode(tokenValue)
        #expect(encodedJSON == json)
    }

    @Test(
        .dtcgEncoder(
            with: .init(tokenValue: .init(color: .hex)),
            outputFormatting: [.sortedKeys, .prettyPrinted]
        )
    )
    func testDecodingEncodingGradientWithOmittedStartStop() async throws {
        let json =
            """
            {
              "$type" : "gradient",
              "$value" : [
                {
                  "color" : "#FFFF00",
                  "position" : 0.666
                },
                {
                  "color" : "#FF0000",
                  "position" : 1
                }
              ]
            }
            """
        let expectedToken: Token = .value(
            .gradient(
                .stops(
                    .stop(.value(.yellow), at: .value(0.666)),
                    .stop(.value(.red), at: .value(1))
                )
            )
        )

        let tokenValue: Token = try json.decode()
        #expect(tokenValue == expectedToken)

        let encodedJSON: String = try .encode(tokenValue)
        #expect(encodedJSON == json)
    }

    @Test(
        .dtcgEncoder(
            with: .init(tokenValue: .init(color: .hex)),
            outputFormatting: [.sortedKeys, .prettyPrinted]
        )
    )
    func testDecodingEncodingGradientUsingReferencesExample() async throws {
        let json =
            """
            {
              "$type" : "gradient",
              "$value" : [
                {
                  "color" : "#000000",
                  "position" : 0
                },
                {
                  "color" : "{brand-primary}",
                  "position" : 0.5
                },
                {
                  "color" : "#000000",
                  "position" : "{position-end}"
                }
              ]
            }
            """
        let expectedToken: Token = .value(
            .gradient(
                .stops(
                    .stop(.value(.black), at: .value(0)),
                    .stop(.alias(TokenPath("brand-primary")), at: .value(0.5)),
                    .stop(.value(.black), at: .alias(TokenPath("position-end")))
                )
            )
        )

        let tokenValue: Token = try json.decode()
        #expect(tokenValue == expectedToken)

        let encodedJSON: String = try .encode(tokenValue)
        #expect(encodedJSON == json)
    }
}
