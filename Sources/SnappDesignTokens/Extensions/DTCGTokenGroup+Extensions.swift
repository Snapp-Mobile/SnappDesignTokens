//
//  File.swift
//
//  Created by Oleksii Kolomiiets on 05.03.2025.
//

import Foundation
import OSLog
 
extension TokenGroup {
    public func resolveAlias(_ path: TokenPath) throws -> Token {
        try resolveAlias(path, root: .group(self), visited: [path])
    }

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

    public func map(
        _ transformation: (_ element: Token) throws -> Token
    ) rethrows -> TokenGroup {
        var group = self
        for (key, token) in group {
            group[key] = try token.map(transformation)
        }
        return group
    }

    public mutating func deepMerge(
        _ other: TokenGroup,
        uniquingKeysWith combine: (Token, Token) -> Token
    ) {
        self = deepMerging(other, uniquingKeysWith: combine)
    }

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
