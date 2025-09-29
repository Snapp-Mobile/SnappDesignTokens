//
//  FlattenProcessor.swift
//
//  Created by Volodymyr Voiko on 09.04.2025.
//

import Foundation

public struct FlattenProcessor: TokenProcessor {
    public let pathConversionStrategy: PathConversionStrategy
    public let flatteningDepth: FlatteningDepth

    public init(
        pathConversionStrategy: PathConversionStrategy = .dotSeparated,
        flatteningDepth: FlatteningDepth = .unlimited
    ) {
        self.pathConversionStrategy = pathConversionStrategy
        self.flatteningDepth = flatteningDepth
    }

    public func process(_ token: Token) async throws -> Token {
        guard case var .group(group) = token else {
            return token
        }
        let uniqueKeysWithValues = flatten(group, path: .init()).map {
            (pathConversionStrategy.convert($0), $1)
        }
        group = TokenGroup(uniqueKeysWithValues: uniqueKeysWithValues)
        return .group(group)
    }

    private func flatten(_ group: TokenGroup, path: TokenPath) -> [([String], Token)] {
        group.flatMap { (key, value) -> [([String], Token)] in
            let fullPath = path.appending(key)
            guard case let .group(subGroup) = value else {
                return [(fullPath.paths, value)]
            }
            guard !flatteningDepth.limitReachedFor(subGroup) else {
                return [(fullPath.paths, value)]
            }
            return flatten(subGroup, path: fullPath)
        }
    }
}

extension FlattenProcessor {
    public enum PathConversionStrategy: Sendable, Equatable {
        case joined(separator: String = ".")
        case convertToCamelCase
        case convertToSnakeCase

        public static let dotSeparated: Self = .joined()
    }

    public enum FlatteningDepth: Sendable {
        case unlimited
        case limitWhere(_ condition: @Sendable (TokenGroup) -> Bool)
    }
}

extension FlattenProcessor.FlatteningDepth {
    func limitReachedFor(_ group: TokenGroup) -> Bool {
        switch self {
        case .unlimited:
            return false
        case .limitWhere(let condition):
            return condition(group)
        }
    }
}

extension FlattenProcessor.PathConversionStrategy {
    func convert(_ paths: [String]) -> String {
        switch self {
        case .joined(let separator):
            return paths.joined(separator: separator)
        case .convertToCamelCase, .convertToSnakeCase:
            return paths
                .enumerated()
                .map({ index, path in
                    var path = path
                    if self == .convertToSnakeCase || index == 0 {
                        path = path.lowercased()
                    } else {
                        path = path.capitalized
                    }
                    return (index, path)
                })
                .map(\.1)
                .joined(
                    separator: self == .convertToCamelCase ? "" : "_"
                )
        }
    }
}

extension TokenProcessor where Self == FlattenProcessor {
    public static func flatten(
        pathConversionStrategy: Self.PathConversionStrategy = .dotSeparated,
        flatteningDepth: Self.FlatteningDepth = .unlimited
    ) -> Self {
        .init(
            pathConversionStrategy: pathConversionStrategy,
            flatteningDepth: flatteningDepth
        )
    }

    public static var flattenDotSeparated: Self { .flatten() }
}
