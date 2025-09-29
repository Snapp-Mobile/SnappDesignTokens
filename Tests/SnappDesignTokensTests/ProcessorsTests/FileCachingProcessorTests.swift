//
//  FileCachingProcessorTests.swift
//
//  Created by Ilian Konchev on 5.03.25.
//

import Foundation
import SnappDesignTokensTestUtils
import Testing

@testable import SnappDesignTokens

struct FileCachingProcessorTests {
    let processor = FileCachingProcessor(
        assetsManager: .init(
            themeCacheRootURL: URL.cachesDirectory.appendingPathComponent(
                "tests-cache"
            ),
            themeName: "testTheme"
        )
    )

    @Test func testCachingAbsolutePath() async throws {
        let inputFileURL: URL = try #require(.alien)
        let token = try inputFileURL.absoluteString.decodeTokenOfType(
            .file,
            wrapInParenthesis: true
        )
        let downloadedDataURLToken = try await processor.process(token)

        let expectedURL = await processor.assetsManager.imageCacheRootURL
            .appendingPathComponent("alien.svg")

        #expect(
            downloadedDataURLToken
                == .value(
                    .file(.init(url: expectedURL))
                )
        )
    }

    @Test(
        .dtcgDecoder(with: .init(file: .init(source: .alienDirectory)))
    ) func testCachingRelativePath() async throws {
        let inputFileURL: URL = try #require(.alien)
        let token = try inputFileURL.absoluteString.decodeTokenOfType(
            .file,
            wrapInParenthesis: true
        )
        let downloadedDataURLToken = try await processor.process(token)
        let expectedURL = await processor.assetsManager.imageCacheRootURL
            .appendingPathComponent("alien.svg")

        #expect(
            downloadedDataURLToken
                == .value(
                    .file(.init(url: expectedURL))
                )
        )
    }
}

extension URL {
    fileprivate static let alien = Bundle.module.url(
        forResource: "alien",
        withExtension: "svg"
    )
    fileprivate static let alienDirectory = Self.alien?
        .deletingLastPathComponent()
}
