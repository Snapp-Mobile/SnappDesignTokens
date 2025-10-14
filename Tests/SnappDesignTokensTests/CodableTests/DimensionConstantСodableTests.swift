//
//  DimensionConstantСodableTests.swift
//
//  Created by Volodymyr Voiko on 10.03.2025.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct DimensionConstantСodableTests {
    @Test(
        .dtcgEncoder(
            outputFormatting: [.prettyPrinted, .sortedKeys]
        ),
        arguments: [
            (
                """
                {
                  "unit" : "px",
                  "value" : 10
                }
                """,
                .init(value: 10, unit: .px)
            ),
            (
                """
                {
                  "unit" : "rem",
                  "value" : 10
                }
                """,
                .init(value: 10, unit: .rem)
            ),
        ] as [(String, DimensionConstant)]
    )
    func testDecodingEncoding(
        json: String,
        expectedValue: DimensionConstant
    ) throws {
        let value: DimensionConstant = try json.decode()
        #expect(value == expectedValue)

        let encodedJSON: String = try .encode(value)
        #expect(encodedJSON == json)
    }
}
