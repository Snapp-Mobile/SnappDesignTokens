//
//  TypographyCodableTests.swift
//
//  Created by Volodymyr Voiko on 25.03.2025.
//

import Testing

@testable import SnappDesignTokens

@Suite
struct TypographyCodableTests {
    @Test(
        .dtcgEncoder(
            outputFormatting: [.sortedKeys, .prettyPrinted]
        ),
        arguments: [
            (
                """
                {
                  "fontFamily" : "Helvetica",
                  "fontSize" : {
                    "unit" : "px",
                    "value" : 16
                  },
                  "fontWeight" : 700,
                  "letterSpacing" : {
                    "unit" : "px",
                    "value" : 0.1
                  },
                  "lineHeight" : 1.2
                }
                """,
                .init(
                    fontFamily: .value(.init("Helvetica")),
                    fontSize: .value(
                        .constant(.init(value: 16, unit: .px))),
                    fontWeight: .value(.bold),
                    letterSpacing: .value(
                        .constant(.init(value: 0.1, unit: .px))),
                    lineHeight: .value(1.2)
                )
            )
        ] as [(String, TypographyValue)])
    func testTypographyValueDecodingEncoding(
        valueString: String,
        expectedValue: TypographyValue
    ) throws {
        let value: TypographyValue = try valueString.decode()
        #expect(value == expectedValue)

        let encodedJSON: String = try .encode(value)
        #expect(encodedJSON == valueString)
    }
}
