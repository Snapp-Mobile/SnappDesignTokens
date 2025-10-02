//
//  FileValueCodableTests.swift
//
//  Created by Ilian Konchev on 5.03.25.
//

import Foundation
import Testing
import UniformTypeIdentifiers

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct FileValueCodableTests {
    @Test(
        arguments: [
            "https://www.example.com/images/image.png",
            "https://www.example.com/image.png",
            "/images/image.png",
            "/image.png",
        ]
    )
    func testDecoding(_ urlString: String) throws {
        let file: FileValue = try "\"\(urlString)\"".decode()
        let expectedURL = try #require(URL(string: urlString))

        #expect(file == .init(url: expectedURL))
    }

    @Test(
        .dtcgDecoder(
            with: .init(file: .init(source: URL(string: "file://path/to/directory")))
        ),
        arguments: [
            (
                "https://www.example.com/images/image.png",
                "https://www.example.com/images/image.png"
            ),
            (
                "https://www.example.com/image.png",
                "https://www.example.com/image.png"
            ),
            (
                "/images/image.png",
                "file://path/to/directory/images/image.png"
            ),
            (
                "/image.png",
                "file://path/to/directory/image.png"
            ),
        ] as [(String, String)]
    )
    func testDecodingWithConfiguration(
        _ urlString: String,
        _ expectedURLString: String
    )
        throws
    {
        let file: FileValue = try "\"\(urlString)\"".decode()
        let expectedURL = try #require(URL(string: expectedURLString))

        #expect(file == .init(url: expectedURL))
    }

    @Test(
        .dtcgEncoder(
            with: .init(
                tokenValue: .init(file: .init(urlEncodingFormat: .absolute)),
            ),
            outputFormatting: [.withoutEscapingSlashes]
        )
    )
    func testAbsoluteEncoding() async throws {
        let fileURLString = "https://www.example.com/images/image.png"
        let fileURL = try #require(URL(string: fileURLString))
        let token = FileValue(url: fileURL)
        let encodedURLString = try String.encode(token)
        #expect(encodedURLString == "\"https://www.example.com/images/image.png\"")
    }

    @Test(
        .dtcgEncoder(
            with: .init(
                tokenValue: .init(file: .init(urlEncodingFormat: .relative))
            ),
            outputFormatting: [.withoutEscapingSlashes]
        )
    )
    func testRelativeEncoding() async throws {
        let fileURLString = "https://www.example.com/images/image.png"
        let fileURL = try #require(URL(string: fileURLString))
        let token = FileValue(url: fileURL)
        let encodedURLString = try String.encode(token)
        #expect(encodedURLString == "\"/images/image.png\"")
    }

    @Test(
        .dtcgEncoder(
            with: .init(
                tokenValue: .init(
                    file: .init(
                        urlEncodingFormat: .relative(
                            from: URL(string: "https://www.example.com/images")
                        )
                    )
                )
            ),
            outputFormatting: [.withoutEscapingSlashes]
        )
    )
    func testRelativeFromEncoding() async throws {
        let fileURLString = "https://www.example.com/images/image.png"
        let fileURL = try #require(URL(string: fileURLString))
        let token = FileValue(url: fileURL)
        let encodedURLString = try String.encode(token)
        #expect(encodedURLString == "\"/image.png\"")
    }
}
