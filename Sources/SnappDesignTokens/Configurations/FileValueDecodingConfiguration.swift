//
//  FileValueDecodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

/// Configuration for decoding file token values.
public struct FileValueDecodingConfiguration: Equatable, Sendable {
    /// Base URL for resolving relative file paths.
    ///
    /// When provided, relative paths in file tokens are resolved against this URL.
    public let sourceLocationURL: URL?

    /// Creates a file value decoding configuration.
    ///
    /// - Parameter sourceLocationURL: Base URL for resolving relative paths (default: `nil`)
    public init(source sourceLocationURL: URL? = nil) {
        self.sourceLocationURL = sourceLocationURL
    }
}
