//
//  BorderValueCodableTests.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import SnappDesignTokensTestUtils
import Testing

@testable import SnappDesignTokens

struct BorderValueCodableTests {
    @Test(
        .dtcgEncoder(
            with: .init(tokenValue: .init(color: .hex)),
            outputFormatting: [.sortedKeys, .prettyPrinted]
        ),
        arguments: [
            (
                """
                {
                  "color" : "#FF0000",
                  "style" : "solid",
                  "width" : {
                    "unit" : "px",
                    "value" : 3
                  }
                }
                """,
                .init(
                    color: .value(.red),
                    width: .value(.constant(.init(value: 3, unit: .px))),
                    style: .value(.line(.solid))
                )
            ),
            (
                """
                {
                  "color" : "{color.focusring}",
                  "style" : {
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
                  },
                  "width" : {
                    "unit" : "px",
                    "value" : 1
                  }
                }
                """,
                .init(
                    color: .alias(.init("color", "focusring")),
                    width: .value(.constant(.init(value: 1, unit: .px))),
                    style: .value(
                        .dash(
                            .init(
                                dashArray: [
                                    .value(
                                        .constant(
                                            .init(value: 0.5, unit: .rem)
                                        )
                                    ),
                                    .value(
                                        .constant(
                                            .init(value: 0.25, unit: .rem)
                                        )
                                    ),
                                ],
                                lineCap: .round
                            )
                        )
                    )
                )
            ),
        ] as [(String, BorderValue)]
    )
    func testSuccessfulDecodingEncoding(
        json: String,
        expectedValue: BorderValue
    ) throws {
        let decodedValue: BorderValue = try json.decode()
        #expect(decodedValue == expectedValue)

        let encodedJSON: String = try .encode(decodedValue)
        #expect(encodedJSON == json)
    }
}
