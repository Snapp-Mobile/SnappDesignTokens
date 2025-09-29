//
//  Token+Extensions.swift
//
//  Created by Volodymyr Voiko on 06.03.2025.
//

import Foundation

public enum TokenResolutionError: Error, Equatable {
    case emptyPath
    case invalidRoot
    case invalidReference(String)
    case invalidValueForReference
    case circularReference
    case unsupportedMerge(String)
}

extension Token {
    public func resolveAlias(_ path: TokenPath) throws -> Token {
        try resolveAlias(path, root: self, visited: [path])
    }

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

    public func map(
        _ transformation: (_ element: Token) throws -> Token
    ) rethrows -> Token {
        guard case .group(let group) = self else {
            return try transformation(self)
        }
        return .group(try group.map(transformation))
    }

    public mutating func deepMerge(
        _ other: Token,
        uniquingKeysWith combine: (Token, Token) -> Token
    ) {
        self = deepMerging(other, uniquingKeysWith: combine)
    }

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
