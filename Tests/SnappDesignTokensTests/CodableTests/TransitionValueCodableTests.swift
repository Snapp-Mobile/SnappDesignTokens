//
//  TransitionValueCodableTests.swift
//
//  Created by Volodymyr Voiko on 03.04.2025.
//

import Testing

@testable import SnappDesignTokens

@Suite
struct TransitionValueCodableTests {
    @Test(
        .dtcgEncoder(
            outputFormatting: [.sortedKeys, .prettyPrinted]
        ),
        arguments: [
            (
                """
                {
                  "delay" : {
                    "unit" : "ms",
                    "value" : 0
                  },
                  "duration" : {
                    "unit" : "ms",
                    "value" : 200
                  },
                  "timingFunction" : [
                    0.5,
                    0,
                    1,
                    1
                  ]
                }
                """,
                .init(
                    duration: .value(.init(value: 200, unit: .millisecond)),
                    delay: .value(.init(value: 0, unit: .millisecond)),
                    timingFunction: .value(.init(x1: 0.5, y1: 0, x2: 1, y2: 1))
                )
            )
        ] as [(String, TransitionValue)]
    )
    func testSuccessfulDecodingEncoding(
        valueString: String,
        expectedValue: TransitionValue
    ) throws {
        let value: TransitionValue = try valueString.decode()
        #expect(value == expectedValue)

        let encodedJSON: String = try .encode(value)
        #expect(valueString == encodedJSON)
    }
}
