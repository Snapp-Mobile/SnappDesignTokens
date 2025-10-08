//
//  TypographyValue.swift
//
//  Created by Volodymyr Voiko on 25.03.2025.
//

import Foundation

public struct TypographyValue: Codable, Equatable, Sendable, CompositeToken {
    /// Font family as ``CompositeTokenValue`` of ``FontFamilyValue``.
    public let fontFamily: CompositeTokenValue<FontFamilyValue>

    /// Font size as ``CompositeTokenValue`` of ``DimensionValue``.
    public let fontSize: CompositeTokenValue<DimensionValue>

    /// Font weight as ``CompositeTokenValue`` of ``FontWeightValue``.
    public let fontWeight: CompositeTokenValue<FontWeightValue>

    /// Letter spacing as ``CompositeTokenValue`` of ``DimensionValue``.
    public let letterSpacing: CompositeTokenValue<DimensionValue>

    /// Line height as ``CompositeTokenValue`` of ``NumberValue``.
    ///
    /// Interpreted as a multiplier of the font size.
    public let lineHeight: CompositeTokenValue<NumberValue>

    /// Decodes all typography properties.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: `DecodingError` if any required property is missing or invalid
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fontFamily = try container.decode(
            CompositeTokenValue<FontFamilyValue>.self,
            forKey: .fontFamily
        )
        self.fontSize = try container.decode(
            CompositeTokenValue<DimensionValue>.self,
            forKey: .fontSize
        )
        self.fontWeight = try container.decode(
            CompositeTokenValue<FontWeightValue>.self,
            forKey: .fontWeight
        )
        self.letterSpacing = try container.decode(
            CompositeTokenValue<DimensionValue>.self,
            forKey: .letterSpacing
        )
        self.lineHeight = try container.decode(
            CompositeTokenValue<NumberValue>.self,
            forKey: .lineHeight
        )
    }

    /// Creates a typography value with all required properties.
    ///
    /// - Parameters:
    ///   - fontFamily: Font family name or reference
    ///   - fontSize: Text size
    ///   - fontWeight: Font thickness
    ///   - letterSpacing: Horizontal character spacing
    ///   - lineHeight: Vertical line spacing (multiplier of font size)
    public init(
        fontFamily: CompositeTokenValue<FontFamilyValue>,
        fontSize: CompositeTokenValue<DimensionValue>,
        fontWeight: CompositeTokenValue<FontWeightValue>,
        letterSpacing: CompositeTokenValue<DimensionValue>,
        lineHeight: CompositeTokenValue<NumberValue>
    ) {
        self.fontFamily = fontFamily
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.letterSpacing = letterSpacing
        self.lineHeight = lineHeight
    }

    /// Resolves all token aliases to their actual values.
    ///
    /// Traverses each property to resolve any `{group.token}` references.
    ///
    /// - Parameter root: Root token containing the complete token tree for lookups
    /// - Throws: Error if any alias cannot be resolved or type mismatch occurs
    public mutating func resolveAliases(root: Token) throws {
        self = .init(
            fontFamily: try fontFamily.resolvingAliases(root: root),
            fontSize: try fontSize.resolvingAliases(root: root),
            fontWeight: try fontWeight.resolvingAliases(root: root),
            letterSpacing: try letterSpacing.resolvingAliases(root: root),
            lineHeight: try lineHeight.resolvingAliases(root: root)
        )
    }
}
