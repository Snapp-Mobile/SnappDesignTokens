//
//  TokenGroup+Extensions.swift
//
//  Created by Oleksii Kolomiiets on 05.03.2025.
//

import Foundation
import OSLog
 
extension TokenGroup {
    /// Resolves an alias reference to its actual token value.
    ///
    /// Traverses the group following the path to find the referenced token.
    ///
    /// - Parameter path: Token path to resolve
    /// - Returns: Resolved token value
    /// - Throws: ``TokenResolutionError`` if path is invalid or references don't exist
    public func resolveAlias(_ path: TokenPath) throws -> Token {
        try resolveAlias(path, root: .group(self), visited: [path])
    }

    /// Resolves an alias reference with circular reference detection.
    ///
    /// Internal method tracking visited paths to detect circular references. Walks through
    /// the path segments, resolving nested groups and following alias chains.
    ///
    /// - Parameters:
    ///   - path: Token path to resolve
    ///   - root: Root token for lookups
    ///   - visitedPaths: Set of paths already visited (for circular reference detection)
    /// - Returns: Resolved token value
    /// - Throws: ``TokenResolutionError`` if resolution fails
    public func resolveAlias(
        _ path: TokenPath,
        root: Token,
        visited visitedPaths: Set<TokenPath>
    ) throws -> Token {
        var remainingPaths = path.paths

        let key = remainingPaths.removeFirst()
        guard let resolved = self[key] else {
            throw TokenResolutionError.invalidReference(key)
        }

        guard remainingPaths.isEmpty else {
            let path = TokenPath(remainingPaths)
            return try resolved.resolveAlias(path, root: root, visited: visitedPaths)
        }

        switch resolved {
        case .alias(let path) where visitedPaths.contains(path):
            throw TokenResolutionError.circularReference
        case .alias(let resolvedPath):
            var visitedPaths = visitedPaths
            visitedPaths.insert(resolvedPath)
            return try root.resolveAlias(resolvedPath, root: root, visited: visitedPaths)
        case .value(.dimension(.expression(var expression))):
            try expression.resolveElements(in: root)
            return .value(.dimension(.expression(expression)))
        case .value, .unknown:
            return resolved
        case .group, .array:
            throw TokenResolutionError.invalidValueForReference
        }
    }

    /// Transforms all tokens in the group using the provided closure.
    ///
    /// Recursively applies transformation to all tokens in the group.
    ///
    /// - Parameter transformation: Closure transforming individual tokens
    /// - Returns: Transformed token group
    /// - Throws: Rethrows errors from transformation closure
    public func map(
        _ transformation: (_ element: Token) throws -> Token
    ) rethrows -> TokenGroup {
        var group = self
        for (key, token) in group {
            group[key] = try token.map(transformation)
        }
        return group
    }

    /// Deeply merges another token group into this one.
    ///
    /// Mutating version of ``deepMerging(_:uniquingKeysWith:)``.
    ///
    /// - Parameters:
    ///   - other: Token group to merge
    ///   - combine: Closure resolving conflicts for duplicate keys
    public mutating func deepMerge(
        _ other: TokenGroup,
        uniquingKeysWith combine: (Token, Token) -> Token
    ) {
        self = deepMerging(other, uniquingKeysWith: combine)
    }

    /// Deeply merges another token group, returning a new group.
    ///
    /// Recursively merges nested groups. For duplicate keys, uses combine closure to resolve.
    ///
    /// - Parameters:
    ///   - other: Token group to merge
    ///   - combine: Closure resolving conflicts for duplicate keys
    /// - Returns: Merged token group
    public func deepMerging(
        _ other: TokenGroup,
        uniquingKeysWith combine: (Token, Token) -> Token
    ) -> TokenGroup {
        merging(other) { current, new in
            guard
                case .group(let currentGroup) = current,
                case .group(let newGroup) = new
            else { return combine(current, new) }
            return .group(currentGroup.deepMerging(newGroup, uniquingKeysWith: combine))
        }
    }
}
