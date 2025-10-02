//
//  CubicBezierValueCodableTests.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

struct CubicBezierValueCodableTests {
    @Test(
        arguments: [
            ("[0.5,0,1,1]", .init(x1: 0.5, y1: 0, x2: 1, y2: 1)),
            ("[0,0,0.5,1]", .init(x1: 0, y1: 0, x2: 0.5, y2: 1)),
        ] as [(String, CubicBezierValue)]
    )
    func testSuccessfulDecodingEncoding(
        valueString: String,
        expectedValue: CubicBezierValue
    ) throws {
        let value: CubicBezierValue = try valueString.decode()
        #expect(value == expectedValue)

        let encodedJSON: String = try .encode(value)
        #expect(encodedJSON == valueString)
    }

    @Test(
        arguments: [
            ("[]", .init(values: [], reason: .incorrectNumberOfValues)),
            ("[0]", .init(values: [0], reason: .incorrectNumberOfValues)),
            (
                "[0, 0]",
                .init(values: [0, 0], reason: .incorrectNumberOfValues)
            ),
            (
                "[0, 0, 0]",
                .init(values: [0, 0, 0], reason: .incorrectNumberOfValues)
            ),
            (
                "[0, 0, 0, 0, 0]",
                .init(
                    values: [0, 0, 0, 0, 0],
                    reason: .incorrectNumberOfValues
                )
            ),
            (
                "[2, 0, 0, 0]",
                .init(values: [2, 0, 0, 0], reason: .xValueOutOfRange)
            ),
            (
                "[0, 0, 2, 0]",
                .init(values: [0, 0, 2, 0], reason: .xValueOutOfRange)
            ),
            (
                "[-1, 0, -1, 0]",
                .init(values: [-1, 0, -1, 0], reason: .xValueOutOfRange)
            ),
        ] as [(String, CubicBezierValueDecodingError)]
    )
    func testFailingDecoding(
        valueString: String,
        expectedError: CubicBezierValueDecodingError
    ) throws {
        #expect(throws: expectedError) {
            let _: CubicBezierValue = try valueString.decode()
        }
    }
}
