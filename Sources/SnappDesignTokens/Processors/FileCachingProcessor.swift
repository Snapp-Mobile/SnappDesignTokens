//
//  FileCachingProcessor.swift
//
//  Created by Ilian Konchev on 5.03.25.
//

import Foundation
import OSLog
import UniformTypeIdentifiers

/// Processor that downloads and caches remote file token assets.
///
/// Downloads files referenced by file tokens to local cache using
/// ``AssetsManager``. Replaces remote URLs with local file URLs. Handles
/// images and fonts with type-specific caching. Logs errors for failed
/// downloads while preserving original tokens.
///
/// ### Example
/// ```swift
/// let manager = AssetsManager(themeName: "myTheme")
/// let processor = FileCachingProcessor(assetsManager: manager)
/// let cached = try await processor.process(token)
/// // File tokens now reference local cached files
/// ```
///
/// - Note: Non-file tokens pass through unchanged. Failed downloads are logged
///   and original token is preserved.
struct FileCachingProcessor: TokenProcessor {
    /// Assets manager for downloading and caching files as ``AssetsManager``.
    let assetsManager: AssetsManager

    /// Creates a file caching processor.
    ///
    /// - Parameter assetsManager: Assets manager instance for file operations
    init(assetsManager: AssetsManager) {
        self.assetsManager = assetsManager
    }

    /// Downloads and caches file token assets.
    ///
    /// Extracts MIME type from file extension, downloads file to local cache,
    /// and returns token with updated local URL. Non-file tokens and tokens
    /// without valid MIME types pass through unchanged.
    ///
    /// - Parameter token: Token tree to process
    /// - Returns: Token with file URLs replaced by local cached paths
    func process(_ token: Token) async throws -> Token {
        guard case let .value(.file(fileInfo)) = token else {
            return token
        }

        let type = UTType(filenameExtension: fileInfo.url.pathExtension)
        guard let mime = type?.preferredMIMEType else {
            return token
        }

        do {
            let localURL = try await assetsManager.download(url: fileInfo.url, mimeType: mime)
            return .value(.file(.init(url: localURL)))
        } catch let error {
            os_log(.error, "Error downloading file %@: %@", fileInfo.url.absoluteString, error.localizedDescription)
            return token
        }
    }
}
