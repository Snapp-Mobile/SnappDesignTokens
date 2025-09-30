//
//  StrokeStyleValueCodableTests.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import Testing

@testable import SnappDesignTokens

@Suite
struct StrokeStyleValueCodableTests {
    @Test(
        .dtcgEncoder(
            outputFormatting: [.sortedKeys, .prettyPrinted]
        ),
        arguments: [
            (
                #""dashed""#,
                .line(.dashed)
            ),
            (
                """
                {
                  "dashArray" : [
                    {
                      "unit" : "rem",
                      "value" : 0.5
                    },
                    {
                      "unit" : "rem",
                      "value" : 0.25
                    }
                  ],
                  "lineCap" : "round"
                }
                """,
                .dash(
                    .init(
                        dashArray: [
                            .value(.constant(.init(value: 0.5, unit: .rem))),
                            .value(.constant(.init(value: 0.25, unit: .rem)))
                        ],
                        lineCap: .round
                    )
                )
            ),
            (
                """
                {
                  "dashArray" : [
                    "{dash-length-medium}",
                    {
                      "unit" : "rem",
                      "value" : 0.25
                    }
                  ],
                  "lineCap" : "butt"
                }
                """,
                .dash(
                    .init(
                        dashArray: [
                            .alias(TokenPath("dash-length-medium")),
                            .value(.constant(.init(value: 0.25, unit: .rem)))
                        ],
                        lineCap: .butt
                    )
                )
            )
        ] as [(String, StrokeStyleValue)]
    )
    func testSuccessfulDecodingEncoding(
        valueString: String,
        expectedValue: StrokeStyleValue
    ) throws {
        let value: StrokeStyleValue = try valueString.decode()
        #expect(value == expectedValue)

        let encodedJSON: String = try .encode(value)
        #expect(encodedJSON == valueString)
    }
}
