//
//  BorderValue.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import Foundation

public struct BorderValue: Equatable, Codable, Sendable, CompositeToken {
    public let color: CompositeTokenValue<ColorValue>
    public let width: CompositeTokenValue<DimensionValue>
    public let style: CompositeTokenValue<StrokeStyleValue>

    public init(
        color: CompositeTokenValue<ColorValue>,
        width: CompositeTokenValue<DimensionValue>,
        style: CompositeTokenValue<StrokeStyleValue>
    ) {
        self.color = color
        self.width = width
        self.style = style
    }

    public mutating func resolveAliases(root: Token) throws {
        self = .init(
            color: try color.resolvingAliases(root: root),
            width: try width.resolvingAliases(root: root),
            style: try style.resolvingAliases(root: root)
        )
    }
}
