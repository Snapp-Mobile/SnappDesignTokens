//
//  GradientColor+Stop.swift
//
//  Created by Volodymyr Voiko on 03.04.2025.
//

import SnappDesignTokens

extension GradientColor {
    public static func stop(
        _ color: CompositeTokenValue<ColorValue>,
        at position: CompositeTokenValue<NumberValue>
    ) -> GradientColor {
        .init(color: color, position: position)
    }
}
