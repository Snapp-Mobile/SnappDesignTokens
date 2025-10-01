//
//  TokenCollectionCodableTests.swift
//
//  Created by Oleksii Kolomiiets on 9/1/25.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct TokenCollectionCodableTests {
    @Test(
        .dtcgEncoder(with: .init(tokenValue: .init(color: .hex))),
        arguments: [
            (
                "\"#FF0000\"",
                .init(values: [.red])
            ),
            (
                "[\"#FF0000\",\"#00FF00\",\"#0000FF\"]",
                .init(values: [.red, .green, .blue])
            ),
        ] as [(String, TokenCollection<ColorValue>)]
    )
    func testSuccessfulDecodingEncoding(
        json: String,
        expectedValue: TokenCollection<ColorValue>
    ) throws {
        let decodedValue: TokenCollection<ColorValue> = try json.decode()
        #expect(decodedValue == expectedValue)

        let encodedJSON: String = try .encode(decodedValue)
        #expect(encodedJSON == json)
    }
}
