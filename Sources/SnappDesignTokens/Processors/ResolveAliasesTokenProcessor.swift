//
//  ResolveAliasesTokenProcessor.swift
//
//  Created by Volodymyr Voiko on 04.03.2025.
//

import Foundation
import OSLog

/// Processor that resolves all token aliases to their actual values.
///
/// Traverses the token tree replacing all alias references (using `{group.token}`
/// syntax) with their resolved values. Handles nested aliases, composite token
/// aliases, and dimension expression aliases. Detects circular references.
///
/// ### Example
/// ```swift
/// // Token tree with aliases:
/// // { "base": { "color": "#ff0000" }, "primary": "{base.color}" }
///
/// let processor: TokenProcessor = .resolveAliases
/// let resolved = try await processor.process(token)
/// // Result: { "base": { "color": "#ff0000" }, "primary": "#ff0000" }
/// ```
///
/// - SeeAlso: ``Token/resolveAliases()`` for alias resolution implementation
public struct ResolveAliasesTokenProcessor: TokenProcessor {
    /// Creates a resolve aliases processor.
    public init() {}

    /// Resolves all aliases in the token tree.
    ///
    /// - Parameter token: Token tree containing aliases to resolve
    /// - Returns: Token tree with all aliases replaced by actual values
    /// - Throws: ``TokenResolutionError`` if alias path is invalid or ``TokenResolutionError/circularReference`` if circular dependency detected
    public func process(_ token: Token) async throws -> Token {
        var resolved = token
        try resolved.resolveAliases()
        return resolved
    }
}

extension TokenProcessor where Self == ResolveAliasesTokenProcessor {
    /// Convenience accessor for resolve aliases processor.
    public static var resolveAliases: Self {
        ResolveAliasesTokenProcessor()
    }
}
