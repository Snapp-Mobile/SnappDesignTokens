//
//  ShadowValue.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import Foundation

/// Represents a single shadow layer for drop or inner shadows.
///
/// Defines shadow appearance with color, offsets, blur, and spread. Multiple instances
/// can be layered for complex effects. All properties support direct values and token aliases.
public struct ShadowValue: Codable, Equatable, Sendable, CompositeToken {
    /// Shadow color as ``CompositeTokenValue`` of ``ColorValue``.
    public let color: CompositeTokenValue<ColorValue>

    /// Horizontal shadow offset as ``CompositeTokenValue`` of ``DimensionValue``.
    ///
    /// Positive moves right, negative moves left.
    public let offsetX: CompositeTokenValue<DimensionValue>

    /// Vertical shadow offset as ``CompositeTokenValue`` of ``DimensionValue``.
    ///
    /// Positive moves down, negative moves up.
    public let offsetY: CompositeTokenValue<DimensionValue>

    /// Blur radius as ``CompositeTokenValue`` of ``DimensionValue``.
    ///
    /// Higher values create more blur. Zero creates sharp shadow.
    public let blur: CompositeTokenValue<DimensionValue>

    /// Shadow expansion/contraction as ``CompositeTokenValue`` of ``DimensionValue``.
    ///
    /// Positive expands shadow, negative contracts it.
    public let spread: CompositeTokenValue<DimensionValue>

    /// Whether shadow renders inside the container.
    ///
    /// `true` for inner shadow, `false` or `nil` (default) for drop shadow.
    public let inset: Bool?

    /// Creates a shadow with the specified properties.
    ///
    /// - Parameters:
    ///   - color: Shadow color
    ///   - offsetX: Horizontal offset
    ///   - offsetY: Vertical offset
    ///   - blur: Blur radius
    ///   - spread: Expansion/contraction amount
    ///   - inset: Whether inner shadow (default: `nil` for drop shadow)
    public init(
        color: CompositeTokenValue<ColorValue>,
        offsetX: CompositeTokenValue<DimensionValue>,
        offsetY: CompositeTokenValue<DimensionValue>,
        blur: CompositeTokenValue<DimensionValue>,
        spread: CompositeTokenValue<DimensionValue>,
        inset: Bool? = nil
    ) {
        self.color = color
        self.offsetX = offsetX
        self.offsetY = offsetY
        self.blur = blur
        self.spread = spread
        self.inset = inset
    }

    /// Decodes all shadow properties.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: `DecodingError` if any required property is missing or invalid
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.color = try container.decode(CompositeTokenValue<ColorValue>.self, forKey: .color)
        self.offsetX = try container.decode(CompositeTokenValue<DimensionValue>.self, forKey: .offsetX)
        self.offsetY = try container.decode(CompositeTokenValue<DimensionValue>.self, forKey: .offsetY)
        self.blur = try container.decode(CompositeTokenValue<DimensionValue>.self, forKey: .blur)
        self.spread = try container.decode(CompositeTokenValue<DimensionValue>.self, forKey: .spread)
        self.inset = try container.decodeIfPresent(Bool.self, forKey: .inset)
    }

    /// Resolves all token aliases to their actual values.
    ///
    /// Traverses each property to resolve any `{group.token}` references.
    ///
    /// - Parameter root: Root token containing the complete token tree for lookups
    /// - Throws: Error if any alias cannot be resolved or type mismatch occurs
    public mutating func resolveAliases(root: Token) throws {
        self = .init(
            color: try color.resolvingAliases(root: root),
            offsetX: try offsetX.resolvingAliases(root: root),
            offsetY: try offsetY.resolvingAliases(root: root),
            blur: try blur.resolvingAliases(root: root),
            spread: try spread.resolvingAliases(root: root),
            inset: inset
        )
    }

    enum CodingKeys: CodingKey {
        case color
        case offsetX
        case offsetY
        case blur
        case spread
        case inset
    }

    /// Encodes all shadow properties.
    ///
    /// - Parameter encoder: Encoder to write data to
    /// - Throws: `EncodingError.invalidValue` if any values are invalid for the given encoder's format
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.color, forKey: .color)
        try container.encode(self.offsetX, forKey: .offsetX)
        try container.encode(self.offsetY, forKey: .offsetY)
        try container.encode(self.blur, forKey: .blur)
        try container.encode(self.spread, forKey: .spread)
        try container.encodeIfPresent(inset, forKey: .inset)
    }
}
