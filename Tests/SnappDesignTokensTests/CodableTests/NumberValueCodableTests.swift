//
//  NumberValueCodableTests.swift
//
//  Created by Volodymyr Voiko on 27.03.2025.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct NumberValueCodableTests {
    @Test(
        .dtcgEncoder(
            outputFormatting: [.sortedKeys, .prettyPrinted]
        ),
        // Note: JSONEncoder encodes Double(1.0) as "1", not "1.0" - tests expecting
        // decimal notation for whole numbers will fail due to JSON number formatting.
        arguments: [-1.1, 1.1, 0.25]
    )
    func testNumberValueDecodingEncoding(_ value: NumberValue) throws {
        let json = """
            {
              "$type" : "number",
              "$value" : \(value)
            }
            """
        let tokenValue: Token = try json.decode()
        #expect(tokenValue == .value(.number(value)))

        let encodedJSON: String = try .encode(tokenValue)
        #expect(json == encodedJSON)
    }
}
