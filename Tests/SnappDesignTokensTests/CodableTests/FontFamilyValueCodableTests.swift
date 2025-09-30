//
//  FontFamilyValueCodableTests.swift
//
//  Created by Volodymyr Voiko on 25.03.2025.
//

import Testing

@testable import SnappDesignTokens

struct FontFamilyValueCodableTests {
    @Test(
        arguments: [
            (#""Comic Sans MS""#, .init("Comic Sans MS")),
            (
                #"["Helvetica","Arial","sans-serif"]"#,
                .init("Helvetica", "Arial", "sans-serif")
            ),

        ] as [(String, FontFamilyValue)])
    func testSuccessfulFontFamilyValueDecodingEncoding(
        valueString: String,
        expectedValue: FontFamilyValue
    ) throws {
        let value: FontFamilyValue = try valueString.decode()
        #expect(value == expectedValue)

        let encodedJSON: String = try .encode(value)
        #expect(encodedJSON == valueString)
    }

    @Test(arguments: [
        "{}",
        "0",
        "[0]",
        "[{}]"
    ])
    func testFailingFontFamilyValueDecoding(
        valueString: String
    ) throws {
        #expect(throws: DecodingError.self) {
            let _: FontFamilyValue = try valueString.decode()
        }
    }
}
