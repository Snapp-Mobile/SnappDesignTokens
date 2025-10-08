//
//  FlattenProcessor.swift
//
//  Created by Volodymyr Voiko on 09.04.2025.
//

import Foundation

/// Processor that flattens nested token groups into a single-level dictionary.
///
/// Converts hierarchical token structures into flat key-value pairs using
/// configurable path naming strategies (dot-separated, camelCase, snake_case).
/// Supports optional depth limiting to preserve specific group levels.
///
/// ### Example
/// ```swift
/// // Input: { "color": { "primary": { "base": "#ff0000" } } }
///
/// let processor: TokenProcessor = .flatten(pathConversionStrategy: .dotSeparated)
/// let flattened = try await processor.process(token)
/// // Output: { "color.primary.base": "#ff0000" }
/// ```
public struct FlattenProcessor: TokenProcessor {
    /// Strategy for converting token paths to flat keys as ``PathConversionStrategy``.
    public let pathConversionStrategy: PathConversionStrategy

    /// Maximum flattening depth as ``FlatteningDepth``.
    public let flatteningDepth: FlatteningDepth

    /// Creates a flatten processor.
    ///
    /// - Parameters:
    ///   - pathConversionStrategy: Path naming strategy (default: `.dotSeparated`)
    ///   - flatteningDepth: Depth limit (default: `.unlimited`)
    public init(
        pathConversionStrategy: PathConversionStrategy = .dotSeparated,
        flatteningDepth: FlatteningDepth = .unlimited
    ) {
        self.pathConversionStrategy = pathConversionStrategy
        self.flatteningDepth = flatteningDepth
    }

    /// Flattens token group hierarchy into single-level dictionary.
    ///
    /// Returns token unchanged if not a group token.
    ///
    /// - Parameter token: Token tree to flatten
    /// - Returns: Flattened token group with combined path keys
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
    /// Strategy for converting hierarchical token paths to flat key names.
    ///
    /// Determines how nested group paths are combined into single keys.
    ///
    /// ### Example
    /// ```swift
    /// // Path: ["color", "primary", "base"]
    /// // .joined(separator: ".") => "color.primary.base"
    /// // .convertToCamelCase => "colorPrimaryBase"
    /// // .convertToSnakeCase => "color_primary_base"
    /// ```
    public enum PathConversionStrategy: Sendable, Equatable {
        /// Joins path segments with specified separator.
        ///
        /// - Parameter separator: String to insert between segments (default: `"."`)
        case joined(separator: String = ".")

        /// Converts path to camelCase.
        ///
        /// First segment lowercased, subsequent segments capitalized.
        case convertToCamelCase

        /// Converts path to snake_case.
        ///
        /// All segments lowercased, joined with underscores.
        case convertToSnakeCase

        /// Dot-separated path strategy (convenience for `.joined()`).
        public static let dotSeparated: Self = .joined()
    }

    /// Controls how deeply nested groups are flattened.
    ///
    /// Enables preserving specific group structures while flattening others.
    public enum FlatteningDepth: Sendable {
        /// Flattens all nested groups without limit.
        case unlimited

        /// Stops flattening when condition returns `true` for a group.
        ///
        /// - Parameter condition: Closure evaluating whether to preserve group structure
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
    /// Creates a flatten processor with specified configuration.
    ///
    /// - Parameters:
    ///   - pathConversionStrategy: Path naming strategy (default: `.dotSeparated`)
    ///   - flatteningDepth: Depth limit (default: `.unlimited`)
    /// - Returns: Configured ``FlattenProcessor``
    public static func flatten(
        pathConversionStrategy: Self.PathConversionStrategy = .dotSeparated,
        flatteningDepth: Self.FlatteningDepth = .unlimited
    ) -> Self {
        .init(
            pathConversionStrategy: pathConversionStrategy,
            flatteningDepth: flatteningDepth
        )
    }

    /// Flatten processor with dot-separated path strategy (convenience accessor).
    public static var flattenDotSeparated: Self { .flatten() }
}
