//
//  UnknownTokenCodableTests.swift
//
//  Created by Ilian Konchev on 17.03.25.
//

import SnappDesignTokensTestUtils
import Foundation
import Testing

@testable import SnappDesignTokens

@Suite
struct UnknownTokenCodableTests {
    @Test(
        .dtcgEncoder(
            outputFormatting: [.sortedKeys, .prettyPrinted]
        )
    )
    func testUnknownTokensParsing() async throws {
        let input = """
            {
              "$metadata" : {
                "tokenSetOrder" : [
                  "global",
                  "semantic",
                  "semantic-dark",
                  "button"
                ]
              },
              "$themes" : [

              ]
            }
            """

        let token: Token = try input.decode()
        let expectedToken: Token = .group([
            "$themes": .array([]),
            "$metadata": .group([
                "tokenSetOrder": .array([
                    .unknown("global"),
                    .unknown("semantic"),
                    .unknown("semantic-dark"),
                    .unknown("button"),
                ])
            ]),
        ])
        #expect(token == expectedToken)

        let encodedJSON: String = try .encode(token)
        #expect(encodedJSON == input)
    }

    @Test(
        .dtcgEncoder(
            outputFormatting: [.sortedKeys, .prettyPrinted]
        )
    )
    func testUnknownArrayParsing() async throws {
        let input = """
            {
              "tokenSetOrder" : [
                "global",
                "semantic",
                "semantic-dark",
                "button"
              ]
            }
            """

        let token: Token = try input.decode()
        let expectedToken: Token = .group([
            "tokenSetOrder": .array([
                .unknown("global"),
                .unknown("semantic"),
                .unknown("semantic-dark"),
                .unknown("button"),
            ])
        ])
        #expect(token == expectedToken)

        let encodedJSON: String = try .encode(token)
        #expect(encodedJSON == input)
    }

    @Test
    func testEmptyArrayParsing() async throws {
        let input = #"{"tokenSetOrder":[]}"#

        let token: Token = try input.decode()
        let expectedToken: Token = .group([
            "tokenSetOrder": .array([])
        ])
        #expect(token == expectedToken)

        let encodedJSON: String = try .encode(token)
        #expect(encodedJSON == input)
    }

    @Test
    func testRootArrayParsing() async throws {
        let input = #"["value"]"#

        let token: Token = try input.decode()
        let expectedToken: Token = .array([.unknown("value")])
        #expect(token == expectedToken)

        let encodedJSON: String = try .encode(token)
        #expect(encodedJSON == input)
    }

    @Test
    func testStringParsing() async throws {
        let input = #"{"tokenSetOrder":"value"}"#

        let token: Token = try input.decode()
        let expectedToken: Token = .group([
            "tokenSetOrder": .unknown("value")
        ])
        #expect(token == expectedToken)

        let encodedJSON: String = try .encode(token)
        #expect(encodedJSON == input)
    }

    @Test(
        .dtcgEncoder(outputFormatting: [.prettyPrinted, .sortedKeys]),
    )
    func testUnknownTypedRepresentation() async throws {
        let input = """
            {
              "borderRadius1" : "%6@#F",
              "borderRadius2" : null,
              "borderWidth1" : "%6@#F",
              "borderWidth2" : null,
              "color1" : "%6@#F",
              "color2" : null,
              "dimension1" : "%6@#F",
              "dimension2" : null,
              "file" : null,
              "sizing1" : "%6@#F",
              "sizing2" : null,
              "spacing1" : "%6@#F",
              "spacing2" : null,
              "unknown" : "%6@#F",
              "unknownArray" : [
                {
                  "unknown" : "%6@#F"
                },
                "%6@#F",
                {

                }
              ],
              "unknownGroup" : {
                "unknown" : "%6@#F"
              }
            }
            """
        let token: Token = try input.decode()
        let expectedToken: Token = .group([
            "color1": .unknown("%6@#F"),
            "color2": .unknown,
            "dimension1": .unknown("%6@#F"),
            "dimension2": .unknown,
            "borderWidth1": .unknown("%6@#F"),
            "borderWidth2": .unknown,
            "borderRadius1": .unknown("%6@#F"),
            "borderRadius2": .unknown,
            "spacing1": .unknown("%6@#F"),
            "spacing2": .unknown,
            "sizing1": .unknown("%6@#F"),
            "sizing2": .unknown,
            "file": .unknown,
            "unknown": .unknown("%6@#F"),
            "unknownGroup": .group([
                "unknown": .unknown("%6@#F")
            ]),
            "unknownArray": .array([
                .group([
                    "unknown": .unknown("%6@#F")
                ]),
                .unknown("%6@#F"),
                .group([:]),
            ]),
        ])
        #expect(token == expectedToken)

        let encodedJSON: String = try .encode(token)
        #expect(encodedJSON == input)
    }
}
