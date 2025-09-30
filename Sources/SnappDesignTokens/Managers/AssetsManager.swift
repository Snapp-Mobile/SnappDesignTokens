//
//  AssetsManager.swift
//
//  Created by Ilian Konchev on 5.03.25.
//

import Foundation
import OSLog

public actor AssetsManager {
    let fileManager: FileManager
    private let imagesFolderName = "images"
    private let fontsFolderName = "fonts"

    var queue: [URL: Task<URL, any Error>] = [:]

    let cacheRootURL: URL
    let imageCacheRootURL: URL
    let fontCacheRootURL: URL

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

    public func cleanup(removeFiles: Bool = true) throws {
        _ = queue.values.map { $0.cancel() }
        queue = [:]
        var isDirectory: ObjCBool = true
        if removeFiles, fileManager.fileExists(atPath: cacheRootURL.path(), isDirectory: &isDirectory) {
            try fileManager.removeItem(at: cacheRootURL)
        }
    }
}
