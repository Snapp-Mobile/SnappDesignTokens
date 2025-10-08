//
//  AssetsManager.swift
//
//  Created by Ilian Konchev on 5.03.25.
//

import Foundation
import OSLog

/// Actor for downloading and caching file token assets.
///
/// Manages local file cache for remote assets referenced in design tokens.
/// Handles concurrent downloads with deduplication, organizes files by type
/// (images, fonts), and provides cleanup functionality.
///
/// Thread-safe actor ensuring single download per URL even with concurrent
/// requests.
///
/// ### Example
/// ```swift
/// let manager = AssetsManager(themeName: "light")
/// let localURL = try await manager.download(
///     url: URL(string: "https://example.com/icon.png")!,
///     mimeType: "image/png"
/// )
/// // File cached at: ~/Documents/light/images/icon.png
/// ```
public actor AssetsManager {
    /// File manager for file system operations.
    let fileManager: FileManager

    /// Images subdirectory name.
    private let imagesFolderName = "images"

    /// Fonts subdirectory name.
    private let fontsFolderName = "fonts"

    /// Active download tasks keyed by URL for deduplication.
    var queue: [URL: Task<URL, any Error>] = [:]

    /// Root directory for all cached files.
    let cacheRootURL: URL

    /// Directory for cached image files.
    let imageCacheRootURL: URL

    /// Directory for cached font files.
    let fontCacheRootURL: URL

    /// Creates an assets manager.
    ///
    /// Initializes cache directories for theme assets. Creates subdirectories
    /// for images and fonts if they don't exist.
    ///
    /// - Parameters:
    ///   - fileManager: File manager instance (default: `.default`)
    ///   - themeCacheRootURL: Root cache directory (default: documents directory)
    ///   - themeName: Theme identifier for cache organization (default: `"default"`)
    public init(
        _ fileManager: FileManager = .default,
         themeCacheRootURL: URL? = nil,
         themeName: String = "default"
    ) {
        self.fileManager = fileManager
        var isDirectory: ObjCBool = true
        let rootURL = themeCacheRootURL ?? URL.documentsDirectory
        self.cacheRootURL = rootURL
        let imageCacheRootURL = rootURL.appendingPathComponent(themeName).appendingPathComponent(imagesFolderName)
        self.imageCacheRootURL = imageCacheRootURL
        if !fileManager.fileExists(atPath: imageCacheRootURL.absoluteString, isDirectory: &isDirectory) {
            do {
                try fileManager.createDirectory(at: imageCacheRootURL, withIntermediateDirectories: true)
            } catch {
                os_log(.error, "Failed to create image cache directory: %@", imageCacheRootURL.absoluteString)
            }
        }
        let fontCacheRootURL = rootURL.appendingPathComponent(themeName).appendingPathComponent(fontsFolderName)
        self.fontCacheRootURL = fontCacheRootURL
        if !fileManager.fileExists(atPath: fontCacheRootURL.absoluteString, isDirectory: &isDirectory) {
            do {
                try fileManager.createDirectory(at: fontCacheRootURL, withIntermediateDirectories: true)
            } catch {
                os_log(.error, "Failed to create font cache directory: %@", fontCacheRootURL.absoluteString)
            }
        }

    }

    /// Downloads file to local cache if not already cached.
    ///
    /// Deduplicates concurrent requests for same URL. Organizes cached files by
    /// MIME type (images/, font/) into subdirectories. Returns immediately if
    /// file already exists in cache.
    ///
    /// - Parameters:
    ///   - url: Remote file URL to download
    ///   - mimeType: MIME type for cache directory selection
    /// - Returns: Local file URL in cache
    /// - Throws: Download or file system error
    @discardableResult
    public func download(url: URL, mimeType: String) async throws -> URL {
        let fileName = url.lastPathComponent

        if let task = queue[url] {
            return try await task.value
        } else {
            let task = Task<URL, Error> { () async throws -> URL in
                var destination = cacheRootURL.appendingPathComponent(fileName)
                switch true {
                case mimeType.hasPrefix("image/"):
                    destination = imageCacheRootURL.appendingPathComponent(fileName)
                case mimeType.hasPrefix("font/"):
                    destination = fontCacheRootURL.appendingPathComponent(fileName)
                default:
                    break
                }

                guard !fileManager.fileExists(atPath: destination.path()) else {
                    return destination
                }

                try await download(url: url, to: destination)
                return destination

            }
            queue[url] = task
            let response = try await task.value
            queue.removeValue(forKey: url)
            return response
        }
    }

    private func download(url: URL, to destination: URL) async throws {
        let (data, _) = try await URLSession.shared.data(from: url)

        guard !data.isEmpty else { return }

        try data.write(to: destination)
    }

    /// Cleans up cache and cancels active downloads.
    ///
    /// Cancels all pending download tasks and optionally removes cached files
    /// from disk.
    ///
    /// - Parameter removeFiles: When `true`, deletes all cached files (default: `true`)
    /// - Throws: File system error if file removal fails
    public func cleanup(removeFiles: Bool = true) throws {
        _ = queue.values.map { $0.cancel() }
        queue = [:]
        var isDirectory: ObjCBool = true
        if removeFiles, fileManager.fileExists(atPath: cacheRootURL.path(), isDirectory: &isDirectory) {
            try fileManager.removeItem(at: cacheRootURL)
        }
    }
}
