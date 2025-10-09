//
//  CompositeToken.swift
//
//  Created by Volodymyr Voiko on 26.03.2025.
//

import Foundation

/// Protocol for composite token types that support alias resolution.
///
/// DTCG composite tokens (Border, Shadow, Typography, etc.) can contain sub-values
/// that reference other tokens using `{group.token}` syntax. Types conforming to this
/// protocol can traverse and resolve these aliases to their actual values.
///
/// Per DTCG specification, tools must resolve references by looking up the referenced
/// token's value. Chained references are supported, but circular references are not allowed.
///
/// ### Example
/// ```swift
/// var border = BorderValue(
///     color: .alias(TokenPath("color", "primary")),
///     width: .value(.constant(.init(value: 2, unit: .px))),
///     style: .value(.line(.solid))
/// )
///
/// // Resolve aliases using root token tree
/// try border.resolveAliases(root: tokenTree)
/// ```
public protocol CompositeToken {
    /// Resolves all token aliases within this composite token to their actual values.
    ///
    /// Traverses the token tree from `root` to find referenced values and replaces
    /// aliases with resolved values. Validates that referenced tokens match expected types.
    ///
    /// - Parameter root: Root token containing the complete token tree for lookups
    /// - Throws: Error if alias cannot be resolved or type mismatch occurs
    mutating func resolveAliases(root: Token) throws
}

extension Array: CompositeToken where Element: CompositeToken {
    /// Resolves aliases for all composite tokens in the array.
    ///
    /// Iterates through each element and resolves its aliases. Used for composite
    /// tokens that contain arrays of sub-values (e.g., Shadow with multiple layers).
    ///
    /// - Parameter root: Root token containing the complete token tree for lookups
    /// - Throws: Error if any element's alias resolution fails
    public mutating func resolveAliases(root: Token) throws {
        for index in indices {
            try self[index].resolveAliases(root: root)
        }
    }
}
