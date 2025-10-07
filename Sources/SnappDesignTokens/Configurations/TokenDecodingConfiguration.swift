//
//  TokenDecodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

/// Configuration for decoding DTCG token files.
///
/// Controls token parsing behavior including file value decoding, type inheritance
/// from parent groups, and custom type mappings for non-standard token types.
///
/// Set on `JSONDecoder` via `tokenDecodingConfiguration` property:
/// ```swift
/// let decoder = JSONDecoder()
/// decoder.tokenDecodingConfiguration = TokenDecodingConfiguration(
///     file: .base64,
///     customTypeMapping: [.custom("icon"): .file]
/// )
/// let tokens = try decoder.decode(Token.self, from: data)
/// ```
public struct TokenDecodingConfiguration: Equatable, Sendable {
    /// Default configuration with no customizations.
    public static let `default` = Self()

    /// File value decoding configuration as ``FileValueDecodingConfiguration``.
    ///
    /// Controls how file token values are decoded (e.g., base64 embedded data).
    public let fileDecodingConfiguration: FileValueDecodingConfiguration?

    /// Parent token type inherited from containing group.
    ///
    /// Automatically set during decoding when a token group has a `$type` property.
    /// Child tokens inherit this type unless they specify their own.
    public var parentType: TokenType?

    /// Custom token type mappings for non-standard types.
    ///
    /// Maps custom type names to standard DTCG types. Enables parsing tokens
    /// with vendor-specific type names (e.g., `icon` → `file`).
    ///
    /// Example:
    /// ```swift
    /// customTypeMapping: [
    ///     .custom("icon"): .file,
    ///     .custom("spacing"): .dimension
    /// ]
    /// ```
    public let customTypeMapping: [TokenType: TokenType]?

    /// Creates a token decoding configuration.
    ///
    /// - Parameters:
    ///   - fileDecodingConfiguration: File value decoding configuration (optional)
    ///   - parentType: Parent token type (optional, set automatically during decoding)
    ///   - customTypeMapping: Custom type mappings dictionary (optional)
    public init(
        file fileDecodingConfiguration: FileValueDecodingConfiguration? =
            nil,
        parentType: TokenType? = nil,
        customTypeMapping: [TokenType: TokenType]? = nil
    ) {
        self.fileDecodingConfiguration = fileDecodingConfiguration
        self.parentType = parentType
        self.customTypeMapping = customTypeMapping
    }
}
