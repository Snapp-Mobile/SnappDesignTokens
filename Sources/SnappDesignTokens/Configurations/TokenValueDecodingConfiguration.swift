//
//  TokenValueDecodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

/// Configuration for decoding token values.
///
/// Controls value-level decoding behavior including type specification, file
/// value decoding, and custom type mappings. Used internally during token
/// parsing to pass decoding context.
///
/// Typically created automatically during decoding but can be set explicitly:
/// ```swift
/// let config = TokenValueDecodingConfiguration(
///     type: .dimension,
///     file: .base64,
///     customTypeMapping: [.custom("icon"): .file]
/// )
/// ```
public struct TokenValueDecodingConfiguration: Equatable, Sendable {
    /// Expected token type for this value as ``TokenType``.
    ///
    /// When set, the decoder expects the value to be of this type. Inherited
    /// from parent group `$type` or explicit token `$type` property.
    public let type: TokenType?

    /// File value decoding configuration as ``FileValueDecodingConfiguration``.
    ///
    /// Controls how file token values are decoded (e.g., base64 embedded data).
    public let fileDecodingConfiguration: FileValueDecodingConfiguration?

    /// Custom token type mappings for non-standard types.
    ///
    /// Maps custom type names to standard DTCG types. Enables parsing tokens
    /// with vendor-specific type names.
    public let customTypeMapping: [TokenType: TokenType]?

    /// Creates a token value decoding configuration.
    ///
    /// - Parameters:
    ///   - type: Expected token type (optional)
    ///   - fileDecodingConfiguration: File value decoding configuration (optional)
    ///   - customTypeMapping: Custom type mappings dictionary (optional)
    public init(
        type: TokenType?,
        file fileDecodingConfiguration: FileValueDecodingConfiguration?,
        customTypeMapping: [TokenType: TokenType]?
    ) {
        self.type = type
        self.fileDecodingConfiguration = fileDecodingConfiguration
        self.customTypeMapping = customTypeMapping
    }
}
