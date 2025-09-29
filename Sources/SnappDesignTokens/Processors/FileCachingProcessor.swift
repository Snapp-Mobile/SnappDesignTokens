//
//  FileCachingProcessor.swift
//
//  Created by Ilian Konchev on 5.03.25.
//

import Foundation
import OSLog
import UniformTypeIdentifiers

struct FileCachingProcessor: TokenProcessor {
    let assetsManager: AssetsManager

    init(assetsManager: AssetsManager) {
        self.assetsManager = assetsManager
    }

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
