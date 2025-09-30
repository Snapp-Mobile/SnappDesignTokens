//
//  ShadowValueCodableTests.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import SnappDesignTokensTestUtils
import Testing

@testable import SnappDesignTokens

@Suite
struct ShadowValueCodableTests {
    @Test(
        .dtcgEncoder(
            with: .init(tokenValue: .init(color: .hex)),
            outputFormatting: [.prettyPrinted, .sortedKeys]
        ),
        arguments: [
            (
                """
                {
                  "blur" : {
                    "unit" : "rem",
                    "value" : 1.5
                  },
                  "color" : "#FF0000",
                  "offsetX" : {
                    "unit" : "rem",
                    "value" : 0.5
                  },
                  "offsetY" : {
                    "unit" : "rem",
                    "value" : 0.5
                  },
                  "spread" : {
                    "unit" : "rem",
                    "value" : 0
                  }
                }
                """,
                .init(
                    color: .value(.red),
                    offsetX: .value(.constant(.init(value: 0.5, unit: .rem))),
                    offsetY: .value(.constant(.init(value: 0.5, unit: .rem))),
                    blur: .value(.constant(.init(value: 1.5, unit: .rem))),
                    spread: .value(.constant(.init(value: 0, unit: .rem)))
                )
            ),
            (
                """
                {
                  "blur" : {
                    "unit" : "rem",
                    "value" : 2.5
                  },
                  "color" : "#FF0000",
                  "inset" : true,
                  "offsetX" : {
                    "unit" : "rem",
                    "value" : 0.5
                  },
                  "offsetY" : {
                    "unit" : "rem",
                    "value" : 0.5
                  },
                  "spread" : {
                    "unit" : "rem",
                    "value" : 0
                  }
                }
                """,
                .init(
                    color: .value(.red),
                    offsetX: .value(.constant(.init(value: 0.5, unit: .rem))),
                    offsetY: .value(.constant(.init(value: 0.5, unit: .rem))),
                    blur: .value(.constant(.init(value: 2.5, unit: .rem))),
                    spread: .value(.constant(.init(value: 0, unit: .rem))),
                    inset: true
                )
            ),
        ] as [(String, ShadowValue)]
    )
    func testSuccessfulDecodingEncoding(
        valueString: String,
        expectedValue: ShadowValue
    ) throws {
        let value: ShadowValue = try valueString.decode()
        #expect(value == expectedValue)

        let encodedJSON: String = try .encode(value)
        #expect(encodedJSON == valueString)
    }

    @Test(arguments: [
        #""""#,
        "{}",
        """
        {
            "color": "#FF0000",
            "offsetX": { "value": 0.5, "unit": "rem" },
            "blur": { "value": 1.5, "unit": "rem" }
        }
        """,
    ])
    func testFailingDecoding(_ valueString: String) throws {
        #expect(throws: DecodingError.self) {
            let _: ShadowValue = try valueString.decode()
        }
    }
}
