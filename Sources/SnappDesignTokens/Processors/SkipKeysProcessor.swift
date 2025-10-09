//
//  SkipKeysProcessor.swift
//
//  Created by Volodymyr Voiko on 09.04.2025.
//

import Foundation

/// Processor that removes specified keys from token groups.
///
/// Filters out unwanted top-level keys from token group dictionaries. Useful
/// for excluding metadata, private tokens, or DTCG special properties before
/// further processing.
///
/// ### Example
/// ```swift
/// let processor: TokenProcessor = .skipKeys("$schema", "$metadata", "_internal")
/// let processed = try await processor.process(token)
/// // Removes $schema, $metadata, and _internal keys from root group
/// ```
public struct SkipKeysProcessor: TokenProcessor {
    /// Set of keys to remove from token groups.
    public let skippedKeys: Set<String>

    /// Creates a skip keys processor.
    ///
    /// - Parameter skippedKeys: Set of key names to remove (default: empty set)
    public init(skippedKeys: Set<String> = []) {
        self.skippedKeys = skippedKeys
    }

    /// Removes specified keys from root token group.
    ///
    /// Only processes top-level keys in the root group. Returns token unchanged
    /// if not a group token.
    ///
    /// - Parameter token: Token tree to process
    /// - Returns: Token tree with specified keys removed from root group
    public func process(_ token: Token) async throws -> Token {
        guard case .group(var group) = token else {
            return token
        }
        for key in skippedKeys {
            group.removeValue(forKey: key)
        }
        return .group(group)
    }
}

extension TokenProcessor where Self == SkipKeysProcessor {
    /// Creates a skip keys processor with variadic key names.
    ///
    /// - Parameter keys: Key names to remove from token groups
    /// - Returns: Configured ``SkipKeysProcessor``
    public static func skipKeys(_ keys: String...) -> Self {
        .init(skippedKeys: .init(keys))
    }

    /// Creates a skip keys processor with array of key names.
    ///
    /// - Parameter keys: Key names to remove from token groups
    /// - Returns: Configured ``SkipKeysProcessor``
    public static func skipKeys(_ keys: [String]) -> Self {
        .init(skippedKeys: .init(keys))
    }
}
