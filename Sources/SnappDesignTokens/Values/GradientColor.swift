//
//  GradientColor.swift
//
//  Created by Oleksii Kolomiiets on 31.03.2025.
//

import Foundation

public struct GradientColor: Equatable, Sendable, Codable {
    public let color: CompositeTokenValue<ColorValue>
    public let position: CompositeTokenValue<NumberValue>

    public init(
        color: CompositeTokenValue<ColorValue>,
        position: CompositeTokenValue<NumberValue>
    ) {
        self.color = color
        self.position = position
    }
}
