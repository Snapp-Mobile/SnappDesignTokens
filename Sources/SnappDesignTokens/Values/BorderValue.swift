//
//  BorderValue.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import Foundation

/// Represents a border with color, width, and stroke style properties.
///
/// Composite token combining three required sub-values. Each property
/// supports both direct values and token aliases that reference other tokens.
public struct BorderValue: Equatable, Codable, Sendable, CompositeToken {
    /// Border color as ``CompositeTokenValue`` of ``ColorValue``.
    public let color: CompositeTokenValue<ColorValue>

    /// Border width as ``CompositeTokenValue`` of ``DimensionValue``.
    public let width: CompositeTokenValue<DimensionValue>

    /// Border stroke style as ``CompositeTokenValue`` of ``StrokeStyleValue``.
    public let style: CompositeTokenValue<StrokeStyleValue>

    /// Creates a border value with specified properties.
    ///
    /// - Parameters:
    ///   - color: Border color as value or alias
    ///   - width: Border width as dimension value or alias
    ///   - style: Stroke style as value or alias
    public init(
        color: CompositeTokenValue<ColorValue>,
        width: CompositeTokenValue<DimensionValue>,
        style: CompositeTokenValue<StrokeStyleValue>
    ) {
        self.color = color
        self.width = width
        self.style = style
    }

    /// Resolves all token aliases to their actual values.
    ///
    /// Recursively resolves aliases in all properties using the token tree.
    ///
    /// - Parameter root: Root token for alias resolution
    /// - Throws: Error if alias reference is invalid or creates circular dependency
    public mutating func resolveAliases(root: Token) throws {
        self = .init(
            color: try color.resolvingAliases(root: root),
            width: try width.resolvingAliases(root: root),
            style: try style.resolvingAliases(root: root)
        )
    }
}
