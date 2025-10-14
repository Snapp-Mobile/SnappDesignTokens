//
//  Token+Extensions.swift
//
//  Created by Volodymyr Voiko on 06.03.2025.
//

import Foundation

/// Error thrown when resolving token aliases.
public enum TokenResolutionError: Error, Equatable {
    /// Token path is empty.
    case emptyPath

    /// Root token is not a group or array.
    case invalidRoot

    /// Referenced path does not exist in token tree.
    case invalidReference(String)

    /// Referenced token is a group instead of a value.
    case invalidValueForReference

    /// Alias references itself directly or indirectly.
    case circularReference

    /// Tokens cannot be merged due to incompatible types.
    case unsupportedMerge(String)
}

extension Token {
    /// Resolves an alias reference to its actual token value.
    ///
    /// Traverses the token tree following the path to find the referenced token. Handles
    /// chained aliases and detects circular references.
    ///
    /// ### Example
    /// ```swift
    /// let token = Token.group([
    ///     "base": .group(["color": .value(.color(.red))]),
    ///     "primary": .alias(TokenPath(["base", "color"]))
    /// ])
    /// let resolved = try token.resolveAlias(TokenPath(["primary"]))  // Returns .value(.color(.red))
    /// ```
    ///
    /// - Parameter path: Token path to resolve
    /// - Returns: Resolved token value
    /// - Throws: ``TokenResolutionError`` if path is invalid, references don't exist, or circular reference detected
    public func resolveAlias(_ path: TokenPath) throws -> Token {
        try resolveAlias(path, root: self, visited: [path])
    }

    /// Resolves an alias reference with circular reference detection.
    ///
    /// Internal method tracking visited paths to detect circular references.
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
        guard !path.paths.isEmpty else {
            throw TokenResolutionError.emptyPath
        }

        switch self {
        case .group(let group):
            return try group.resolveAlias(path, root: root, visited: visitedPaths)
        case .array(let tokens):
            for token in tokens.reversed() {
                guard
                    let resolved = try? token.resolveAlias(
                        path,
                        root: root,
                        visited: visitedPaths
                    )
                else { continue }
                return resolved
            }

            throw TokenResolutionError.invalidReference(path.rawValue)
        case .alias, .value, .unknown:
            throw TokenResolutionError.invalidRoot
        }
    }

    /// Resolves all alias references in the token tree.
    ///
    /// Recursively traverses the token tree, replacing all alias references with their
    /// actual values. Also resolves aliases within composite tokens and dimension expressions.
    ///
    /// - Throws: ``TokenResolutionError`` if any alias cannot be resolved
    public mutating func resolveAliases() throws {
        try resolveAliases(root: self)
    }

    private mutating func resolveAliases(root: Token) throws {
        self = try map { element in
            switch element {
            case .alias(let path):
                return try root.resolveAlias(path)
            case .value(.dimension(.expression(var expression))):
                try expression.resolveElements(in: root)
                return .value(.dimension(.expression(expression)))
            case .value(.typography(var typography)):
                try typography.resolveAliases(root: root)
                return .value(.typography(typography))
            case .value(.shadow(var shadow)):
                try shadow.resolveAliases(root: root)
                return .value(.shadow(shadow))
            case .value(.strokeStyle(var strokeStyle)):
                try strokeStyle.resolveAliases(root: root)
                return .value(.strokeStyle(strokeStyle))
            case .value(.border(var border)):
                try border.resolveAliases(root: root)
                return .value(.border(border))
            case .value(.transition(var transition)):
                try transition.resolveAliases(root: root)
                return .value(.transition(transition))
            case .array(var tokens):
                for (index, var token) in tokens.enumerated() {
                    try token.resolveAliases(root: root)
                    tokens[index] = token
                }
                return .array(tokens)
            case .group,
                .value(.dimension), .value(.color), .value(.duration),
                .value(.file), .value(.fontFamily), .value(.fontWeight),
                .value(.number), .value(.gradient), .value(.cubicBezier),
                .unknown:
                return element
            }
        }
    }

    /// Transforms all tokens in the tree using the provided closure.
    ///
    /// Recursively applies transformation to all tokens in groups and arrays.
    ///
    /// - Parameter transformation: Closure transforming individual tokens
    /// - Returns: Transformed token tree
    /// - Throws: Rethrows errors from transformation closure
    public func map(
        _ transformation: (_ element: Token) throws -> Token
    ) rethrows -> Token {
        guard case .group(let group) = self else {
            return try transformation(self)
        }
        return .group(try group.map(transformation))
    }

    /// Deeply merges another token tree into this one.
    ///
    /// Mutating version of ``deepMerging(_:uniquingKeysWith:)``.
    ///
    /// - Parameters:
    ///   - other: Token tree to merge
    ///   - combine: Closure resolving conflicts for duplicate keys
    public mutating func deepMerge(
        _ other: Token,
        uniquingKeysWith combine: (Token, Token) -> Token
    ) {
        self = deepMerging(other, uniquingKeysWith: combine)
    }

    /// Deeply merges another token tree, returning a new token.
    ///
    /// Recursively merges group tokens. For duplicate keys, uses combine closure to resolve.
    /// Non-group tokens are combined directly.
    ///
    /// - Parameters:
    ///   - other: Token tree to merge
    ///   - combine: Closure resolving conflicts for duplicate keys
    /// - Returns: Merged token tree
    public func deepMerging(
        _ other: Token,
        uniquingKeysWith combine: (Token, Token) -> Token
    ) -> Token {
        guard
            case .group(let group) = self,
            case .group(let otherGroup) = other
        else {
            return combine(self, other)
        }
        return .group(group.deepMerging(otherGroup, uniquingKeysWith: combine))
    }
}

extension DimensionExpression {
    /// Resolves all alias references within the expression.
    ///
    /// Replaces alias elements with their actual dimension values. Handles both constant
    /// dimensions and nested expressions.
    ///
    /// - Parameter root: Root token containing the complete token tree for lookups
    /// - Throws: ``TokenResolutionError`` if any alias cannot be resolved or references non-dimension token
    public mutating func resolveElements(in root: Token) throws {
        elements = try elements.flatMap { element in
            guard case .alias(let path) = element else {
                return [element]
            }

            let resolved = try root.resolveAlias(path)

            switch resolved {
            case .value(.dimension(.constant(let value))):
                return [.value(value)]
            case .value(.dimension(.expression(var expression))):
                try expression.resolveElements(in: root)
                var elements = expression.elements
                elements.insert(.operation(.leftParen), at: elements.startIndex)
                elements.insert(.operation(.rightParen), at: elements.endIndex)
                return elements
            case .value, .group, .alias, .array, .unknown:
                throw TokenResolutionError.invalidValueForReference
            }
        }
    }
}
