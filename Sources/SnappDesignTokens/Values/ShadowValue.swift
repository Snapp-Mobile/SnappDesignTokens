//
//  ShadowValue.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import Foundation

/// Represents a value of shadow style for design tokens.
///
/// This structure conforms to the Design Tokens Community Group (DTCG) specification for value of shadow tokens, supporting both drop shadows and inner shadows with configurable properties.
///
/// ### Usage
/// ```swift
/// // Create a drop shadow
/// let color = try ColorValue(hex: "#000000")
/// let dropShadow = ShadowValue(
///     color: .value(color),
///     offsetX: .value(DimensionValue(value: 2, unit: .px)),
///     offsetY: .value(DimensionValue(value: 4, unit: .px)),
///     blur: .value(DimensionValue(value: 8, unit: .px)),
///     spread: .value(DimensionValue(value: 0, unit: .px))
/// )
///
/// // Create an inner shadow
/// let innerShadow = ShadowValue(
///     color: .alias(TokenPath("shadow.inner.color")),
///     offsetX: .value(DimensionValue(value: 0, unit: .px)),
///     offsetY: .value(DimensionValue(value: 2, unit: .px)),
///     blur: .value(DimensionValue(value: 4, unit: .px)),
///     spread: .value(DimensionValue(value: -1, unit: .px)),
///     inset: true
/// )
/// ```
public struct ShadowValue: Codable, Equatable, Sendable, CompositeToken {
    /// The color of the shadow.
    ///
    /// The value of this property MUST be a valid color value or a reference to a color token.
    public let color: CompositeTokenValue<ColorValue>

    /// The horizontal offset that shadow has from the element it is applied to.
    ///
    /// The value of this property MUST be a valid dimension value or a reference to a dimension token.
    /// Positive values move the shadow to the right, negative values move it to the left.
    public let offsetX: CompositeTokenValue<DimensionValue>

    /// The vertical offset that shadow has from the element it is applied to.
    ///
    /// The value of this property MUST be a valid dimension value or a reference to a dimension token.
    /// Positive values move the shadow downward, negative values move it upward.
    public let offsetY: CompositeTokenValue<DimensionValue>

    /// The blur radius that is applied to the shadow.
    ///
    /// The value of this property MUST be a valid dimension value or a reference to a dimension token.
    /// Higher values create more blurred shadows, while a value of 0 creates a sharp shadow.
    public let blur: CompositeTokenValue<DimensionValue>

    /// The amount by which to expand or contract the shadow.
    ///
    /// The value of this property MUST be a valid dimension value or a reference to a dimension token.
    /// Positive values expand the shadow, negative values contract it.
    public let spread: CompositeTokenValue<DimensionValue>

    /// Whether this shadow is inside the containing shape ("inner shadow").
    ///
    /// When `true`, creates an inner shadow rendered inside the container.
    /// When `false` or `nil` (default), creates a drop shadow or box shadow rendered outside the container.
    public let inset: Bool?

    /// Creates a new `ShadowValue` value with the specified properties.
    ///
    /// - Parameters:
    ///   - color: The color of the shadow
    ///   - offsetX: The horizontal offset of the shadow
    ///   - offsetY: The vertical offset of the shadow
    ///   - blur: The blur radius applied to the shadow
    ///   - spread: The amount by which to expand or contract the shadow
    ///   - inset: Whether this is an inner shadow (default: `nil` for drop shadow)
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

    /// Creates a `ShadowValue` by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from
    /// - Throws: `DecodingError` if the data is corrupted or if any required values are missing
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.color = try container.decode(CompositeTokenValue<ColorValue>.self, forKey: .color)
        self.offsetX = try container.decode(CompositeTokenValue<DimensionValue>.self, forKey: .offsetX)
        self.offsetY = try container.decode(CompositeTokenValue<DimensionValue>.self, forKey: .offsetY)
        self.blur = try container.decode(CompositeTokenValue<DimensionValue>.self, forKey: .blur)
        self.spread = try container.decode(CompositeTokenValue<DimensionValue>.self, forKey: .spread)
        self.inset = try container.decodeIfPresent(Bool.self, forKey: .inset)
    }

    /// Resolves all alias references within this shadow value using the provided root token.
    ///
    /// - Parameter root: The root design token containing all token definitions
    /// - Throws: `Error` if any alias references cannot be resolved
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

    /// Encodes this `ShadowValue` into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to
    /// - Throws: `EncodingError` if any values are invalid for the given encoder's format
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
