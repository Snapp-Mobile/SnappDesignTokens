//
//  DurationValueCodableTests.swift
//
//  Created by Volodymyr Voiko on 31.03.2025.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct DurationValueCodableTests {
    @Test(
        .dtcgEncoder(
            outputFormatting: [.sortedKeys]
        ),
        arguments: [
            (
                #"{"unit":"ms","value":100}"#,
                .init(value: 100, unit: .millisecond)
            ),
            (
                #"{"unit":"s","value":1.5}"#,
                .init(value: 1.5, unit: .second)
            )
        ] as [(String, DurationValue)])
    func testSuccessfulDecodingEncoding(
        valueString: String,
        expectedValue: DurationValue
    ) throws {
        let value: DurationValue = try valueString.decode()
        #expect(value == expectedValue)

        let encodedJSON: String = try .encode(value)
        #expect(encodedJSON == valueString)
    }

    @Test(arguments: [
        #"{ "value": 100, "unit": "sec" }"#,
        #"{ "value": "", "unit": "s" }"#,
        #"{ "value": {}, "unit": {} }"#,
        "{}"
    ])
    func testFailingDecoding(
        valueString: String
    ) throws {
        #expect(throws: DecodingError.self) {
            let _: DurationValue = try valueString.decode()
        }
    }
}
