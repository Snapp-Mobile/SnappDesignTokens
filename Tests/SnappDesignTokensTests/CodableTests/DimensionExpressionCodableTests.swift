//
//  DimensionExpressionCodableTests.swift
//
//  Created by Oleksii Kolomiiets on 06.03.2025.
//

import Foundation
import Testing

@testable import SnappDesignTokens

@Suite
struct DimensionExpressionCodableTests {
    @Test(
        .dtcgEncoder(outputFormatting: [.withoutEscapingSlashes, .sortedKeys]),
        arguments: [
            (
                #"{"$type":"dimension","$value":"12.0px*3.0px+1.0px"}"#,
                .value(
                    .dimension(
                        .expression(
                            .value(.init(value: 12, unit: .px)),
                            .operation(.multiply),
                            .value(.init(value: 3, unit: .px)),
                            .operation(.add),
                            .value(.init(value: 1, unit: .px))
                        )
                    )
                )
            ),
            (
                #"{"$type":"dimension","$value":"1.0rem*5.0px/12.0px-3.0px"}"#,
                .value(
                    .dimension(
                        .expression(
                            .value(.init(value: 1, unit: .rem)),
                            .operation(.multiply),
                            .value(.init(value: 5, unit: .px)),
                            .operation(.divide),
                            .value(.init(value: 12, unit: .px)),
                            .operation(.subtract),
                            .value(.init(value: 3, unit: .px))
                        )
                    )
                )
            ),
            (
                #"{"$type":"dimension","$value":"2.0px*{base.value}"}"#,
                .value(
                    .dimension(
                        .expression(
                            .value(.init(value: 2, unit: .px)),
                            .operation(.multiply),
                            .alias(.init(["base", "value"]))
                        )
                    )
                )
            ),
        ] as [(String, Token)]
    )
    func testSuccessDecodingEncoding(
        json: String,
        expectedToken: Token
    ) throws {
        let token: Token = try json.decode()
        #expect(token == expectedToken)

        let encodedJSON: String = try .encode(token)
        #expect(encodedJSON == json)
    }

    @Test(
        arguments: [
            #"{ "$value": "12pt", "$type": "dimension" }"#,
            #"{ "$value": "12*^pt", "$type": "dimension" }"#,
        ]
    )
    func testDecodingToUnknownToken(json: String) throws {
        let token: Token = try json.decode()
        if case .unknown(let unknownToken) = token {
            #expect(unknownToken.rawValue?.contains("12") == true)
        } else {
            Issue.record("\(token)")
        }
    }

    @Test
    func testValueFromRawValue() async throws {
        let dimension = try #require(
            DimensionExpressionElement(rawValue: #"2.0px"#)
        )
        #expect(dimension == .value(.init(value: 2, unit: .px)))
    }

    @Test
    func testAliasFromRawValue() async throws {
        let dimension = try #require(
            DimensionExpressionElement(rawValue: #"{base.value}"#)
        )
        #expect(dimension == .alias(TokenPath(["base", "value"])))
    }

    @Test
    func testOperationFromRawValue() async throws {
        let dimension = try #require(DimensionExpressionElement(rawValue: "/"))
        #expect(dimension == .operation(.divide))
    }

    @Test(
        arguments: [
            "",
            " ",
            #"\"#,
        ]
    )
    func testErrorFromRawValue(_ rawValue: String) async throws {
        let expectedError = DimensionExpressionElementParseError.invalidFormat
        #expect(throws: expectedError) { _ = try DimensionExpressionElement(from: rawValue) }
    }

    @Test(
        arguments: [
            #"" ""#,
            #""""#,
        ]
    )
    func testDecodingInvalidFormatToken(json: String) throws {
        let expectedError = DimensionExpressionParsingError.invalidFormat
        #expect(throws: expectedError) { let _: DimensionExpression = try json.decode() }
    }

    @Test(
        arguments: [
            #"">""#,
            #""<""#,
        ]
    )
    func testDecodingInvalidElementToken(json: String) throws {
        let expectedError = DimensionExpressionParsingError.invalidElement(json.replacingOccurrences(of: #"""#, with: ""))
        #expect(throws: expectedError) { let _: DimensionExpression = try json.decode() }
    }

    @Test
    func testDecodingCorruptedToken() throws {
        #expect(throws: DecodingError.self) { let _: DimensionExpression = try #""#.decode() }
    }

    @Test
    func testEmptyAlias() async throws {
        let expectedError = TokenPathParsingError.emptyAlias
        #expect(throws: expectedError) { _ = try TokenPath(from: #"{}"#) }
    }

    @Test
    func testBracketsMismatch() async throws {
        let expectedError = TokenPathParsingError.bracketsMismatch
        #expect(throws: expectedError) { _ = try TokenPath(from: #"{{}"#) }
    }
}
