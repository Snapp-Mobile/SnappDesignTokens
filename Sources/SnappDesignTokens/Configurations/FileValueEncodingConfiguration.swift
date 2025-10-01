//
//  FileValueEncodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

/// Configuration for encoding file token values.
public struct FileValueEncodingConfiguration: Equatable, Sendable {
    /// Default configuration (absolute URLs).
    public static let `default`: Self = .init()

    /// URL encoding format (absolute or relative).
    public let urlEncodingFormat: FileValueURLEncodingFormat

    /// Creates a file value encoding configuration.
    ///
    /// - Parameter urlEncodingFormat: URL format for encoding (default: absolute)
    public init(urlEncodingFormat: FileValueURLEncodingFormat = .default) {
        self.urlEncodingFormat = urlEncodingFormat
    }
}
