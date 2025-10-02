//
//  FontWeightValueCodableTests.swift
//
//  Created by Volodymyr Voiko on 27.03.2025.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct FontWeightValueCodableTests {
    @Test(arguments: [1, 12, 999])
    func testSuccessfulValueDecodingEncoding(uIntValue: UInt) throws {
        let value: FontWeightValue = try String(describing: uIntValue).decode()
        let expectedValue = try #require(FontWeightValue(rawValue: uIntValue))
        #expect(value == expectedValue)

        let json = "\(uIntValue)"
        let encodedJSON: String = try .encode(value)
        #expect(encodedJSON == json)
    }

    @Test(arguments: [0, 1001])
    func testFailingValueDecoding(uIntValue: UInt) throws {
        #expect(throws: FontWeightValueDecodingError.invalidValue(uIntValue)) {
            let _: FontWeightValue = try String(describing: uIntValue).decode()
        }
    }

    @Test(arguments: FontWeightValue.Alias.allCases)
    func testSuccessfulAliasDecodingEncoding(alias: FontWeightValue.Alias) throws {
        let aliasValueToDecode = "\"\(alias.rawValue)\""
        let value: FontWeightValue = try aliasValueToDecode.decode()
        let expectedValue = FontWeightValue(alias: alias)
        #expect(value == expectedValue)

        let encodedJSON: String = try .encode(value)
        #expect(encodedJSON == aliasValueToDecode)
    }

    @Test
    func testFailingAliasDecoding() throws {
        #expect(
            throws: FontWeightValueDecodingError.invalidAlias("invalid")
        ) {
            let _: FontWeightValue = try "\"invalid\"".decode()
        }
    }
}
