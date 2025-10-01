//
//  TokenCodableTests.swift
//
//  Created by Volodymyr Voiko on 03.03.2025.
//

import Foundation
import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct TokenCodableTests {
    @Test(
        .dtcgEncoder(
            with: .init(
                tokenValue: .init(
                    color: .hex,
                    measurement: .value(withUnit: true)
                )
            ),
        ),
        arguments: [
            (
                #"{"$type":"dimension","$value":"0.25rem"}"#,
                .value(.dimension(.constant(.init(value: 0.25, unit: .rem))))
            ),
            (
                #"{"$type":"dimension","$value":"0.32px"}"#,
                .value(.dimension(.constant(.init(value: 0.32, unit: .px))))
            ),
            (
                #"{"$type":"dimension","$value":"32.0px"}"#,
                .value(.dimension(.constant(.init(value: 32, unit: .px))))
            ),
            (
                #"{"$type":"dimension","$value":"12.0px"}"#,
                .value(.dimension(.constant(.init(value: 12, unit: .px))))
            ),
            (
                #"{"$type":"dimension","$value":"12.0px"}"#,
                .value(.dimension(.constant(.init(value: 12, unit: .px))))
            ),
            (
                #"{"$type":"dimension","$value":"24.0px"}"#,
                .value(.dimension(.init(value: 24, unit: .px)))
            ),
        ] as [(String, Token)]
    )
    func testDecodingAndEncoding_valueAndUnit(
        possibleJSON: String,
        expected: Token
    ) async throws {
        let token: Token = try possibleJSON.decode()
        #expect(token == expected)

        let encodedJSON: String = try .encode(token)
        #expect(encodedJSON == possibleJSON)
    }

    @Test(
        .dtcgEncoder(
            with: .init(tokenValue: .init(measurement: .value())),
        ),
        arguments: [
            (
                #"{"$type":"dimension","$value":0.32}"#,
                .value(.dimension(.constant(.init(value: 0.32, unit: .px))))
            ),
            (
                #"{"$type":"dimension","$value":32}"#,
                .value(.dimension(.constant(.init(value: 32, unit: .px))))
            ),
            (
                #"{"$type":"dimension","$value":12}"#,
                .value(.dimension(.constant(.init(value: 12, unit: .px))))
            ),
            (
                #"{"$type":"dimension","$value":24}"#,
                .value(.dimension(.init(value: 24, unit: .px)))
            ),
        ] as [(String, Token)]
    )
    func testDecodingAndEncoding_value(
        possibleJSON: String,
        expected: Token
    ) async throws {
        let token: Token = try possibleJSON.decode()
        #expect(token == expected)

        let encodedJSON: String = try .encode(token)
        #expect(encodedJSON == possibleJSON)
    }

    @Test(
        .dtcgEncoder(
            with: .init(tokenValue: .init(color: .hex, measurement: .value(withUnit: true))),
            outputFormatting: [.prettyPrinted, .sortedKeys]
        ),
        arguments: [
            (
                """
                {
                  "group" : {
                    "sub-group" : {
                      "token" : {
                        "$type" : "color",
                        "$value" : "#FF0000"
                      }
                    }
                  }
                }
                """,
                Token.group(
                    [
                        "group": .group([
                            "sub-group": .group([
                                "token": .value(.color(.red))
                            ])
                        ])
                    ]
                )
            ),
            (
                """
                {
                  "colors" : {
                    "red" : {
                      "$type" : "color",
                      "$value" : "#FF0000"
                    },
                    "surface" : {
                      "depth" : {
                        "level0" : {
                          "$type" : "color",
                          "$value" : "#FFFFFF"
                        },
                        "level1" : {
                          "$type" : "color",
                          "$value" : "#000000"
                        }
                      }
                    }
                  }
                }
                """,
                .group([
                    "colors": .group([
                        "red": .value(.color(.red)),
                        "surface": .group([
                            "depth": .group([
                                "level0": .value(.color(.white)),
                                "level1": .value(.color(.black)),
                            ])
                        ]),
                    ])
                ])
            ),
            (
                """
                {
                  "colors" : {
                    "values" : [
                      {
                        "$type" : "color",
                        "$value" : "#FF0000"
                      }
                    ]
                  }
                }
                """,
                .group([
                    "colors": .group([
                        "values": .array([
                            .value(.color(.red))
                        ])
                    ])
                ])
            ),
            (
                """
                {
                  "root" : {
                    "nested" : {
                      "red" : {
                        "$type" : "color",
                        "$value" : "#FF0000"
                      },
                      "spacing" : {
                        "$type" : "dimension",
                        "$value" : "10.0px"
                      }
                    }
                  }
                }
                """,
                .group([
                    "root": .group([
                        "nested": .group([
                            "red": .value(.color(.red)),
                            "spacing": .value(
                                .dimension(
                                    .constant(
                                        .init(value: 10, unit: .px)
                                    )
                                )
                            ),
                        ])
                    ])
                ])
            ),
        ] as [(String, Token)]
    )
    func testValueDecodingEncoding_prettyPrinted(
        json: String,
        expected: Token
    ) async throws {
        let token: Token = try json.decode()
        #expect(token == expected)

        let encodedJSON: String = try .encode(token)
        #expect(encodedJSON == json)
    }

    @Test(
        .dtcgEncoder(
            outputFormatting: [.sortedKeys, .withoutEscapingSlashes]
        ),
        arguments: [
            (
                #"{"$type":"dimension","$value":"120.0px/10.0px"}"#,
                Token.value(
                    .dimension(
                        .expression(
                            .value(.value(120)),
                            .operation(.divide),
                            .value(DimensionConstant(value: 10, unit: .px))
                        )
                    )
                )
            )
        ]
    )
    func testValueWithMathExpressionsDecodingEncoding(
        json: String,
        expected: Token
    ) async throws {
        let token: Token = try json.decode()
        #expect(token == expected)

        let encodedJSON: String = try .encode(token)
        #expect(encodedJSON == json)
    }

    @Test(
        arguments: [
            #"{ "$type": "dimension", "$value": "p32px" }"#,
            #"{ "$type": "dimension", "$value": "px0.25rem" }"#,
        ]
    )
    func testFailingValueDecoding(
        json: String
    ) async throws {
        do {
            let _: Token = try json.decode()
        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted(let context):
                #expect(context.debugDescription == "Unsupported token value")
            default:
                Issue.record(error)
            }
        }
    }
}
