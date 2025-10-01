//
//  ColorValueCodableTests.swift
//
//  Created by Volodymyr Voiko on 16.05.2025.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

struct ColorValueCodableTests {
    @Test(
        .dtcgEncoder(with: .init(tokenValue: .init(color: .hex))),
        arguments: [
            ("\"#FF0000\"", .red),
            ("\"#00FF00\"", .green),
            ("\"#0000FF\"", .blue),
        ] as [(String, ColorValue)]
    )
    func testSuccesfullDecodingEncodingHEX(
        _ json: String,
        expectedValue: ColorValue
    ) async throws {
        let decodedValue: ColorValue = try json.decode()
        #expect(decodedValue == expectedValue)

        let encodedJSON: String = try .encode(decodedValue)
        #expect(encodedJSON == json)
    }

    @Test(
        arguments: [
            (
                """
                {"colorSpace":"srgb","components":[1,0,0]}
                """,
                .init(colorSpace: .srgb, components: [1, 0, 0]),
                """
                {"alpha":1,"colorSpace":"srgb","components":[1,0,0]}
                """
            ),
            (
                "\"#FF0000\"",
                .red,
                """
                {"alpha":1,"colorSpace":"srgb","components":[1,0,0],"hex":"#FF0000"}
                """
            ),
            (
                "\"#00FF00\"",
                .green,
                """
                {"alpha":1,"colorSpace":"srgb","components":[0,1,0],"hex":"#00FF00"}
                """
            ),
            (
                "\"#0000FF\"",
                .blue,
                """
                {"alpha":1,"colorSpace":"srgb","components":[0,0,1],"hex":"#0000FF"}
                """
            ),
            (
                """
                {
                    "colorSpace": "hsl",
                    "components": ["none", 0, 100],
                    "alpha": 1,
                    "hex": "#ffffff"
                }
                """,
                .init(
                    colorSpace: .hsl,
                    components: [.none, 0, 100],
                    hex: "#ffffff"
                ),
                """
                {"alpha":1,"colorSpace":"hsl","components":["none",0,100],"hex":"#ffffff"}
                """
            ),
            (
                """
                {
                    "colorSpace": "lab",
                    "components": [60.17, 93.54, -60.5],
                    "alpha": 1,
                    "hex": "#ff00ff"
                }
                """,
                .init(
                    colorSpace: .lab,
                    components: [60.17, 93.54, -60.5],
                    hex: "#ff00ff"
                ),
                """
                {"alpha":1,"colorSpace":"lab","components":[60.17,93.54,-60.5],"hex":"#ff00ff"}
                """
            ),
        ] as [(String, ColorValue, String)]
    )
    func testSuccesfullDecodingEncoding(
        _ json: String,
        expectedValue: ColorValue,
        expectedEncodedJSON: String
    ) async throws {
        let decodedValue: ColorValue = try json.decode()
        #expect(decodedValue == expectedValue)

        let encodedJSON: String = try .encode(decodedValue)
        #expect(encodedJSON == expectedEncodedJSON)
    }
}
