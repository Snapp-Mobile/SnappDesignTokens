//
//  TypographyValue.swift
//
//  Created by Volodymyr Voiko on 25.03.2025.
//

import Foundation

public struct TypographyValue: Codable, Equatable, Sendable, CompositeToken {
    public let fontFamily: CompositeTokenValue<FontFamilyValue>
    public let fontSize: CompositeTokenValue<DimensionValue>
    public let fontWeight: CompositeTokenValue<FontWeightValue>
    public let letterSpacing: CompositeTokenValue<DimensionValue>
    public let lineHeight: CompositeTokenValue<NumberValue>

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
