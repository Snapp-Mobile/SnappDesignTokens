//
//  ColorValue+Mocks.swift
//
//  Created by Volodymyr Voiko on 04.03.2025.
//

import SnappDesignTokens

extension ColorValue {
    public static let red = ColorValue(
        colorSpace: .srgb,
        components: [1, 0, 0],
        alpha: 1,
        hex: "#FF0000"
    )
    public static let reddish = ColorValue(
        colorSpace: .srgb,
        components: [1, 0, 0],
        alpha: 0.2,
        hex: "#FF0000"
    )
    public static let blue = ColorValue(
        colorSpace: .srgb,
        components: [0, 0, 1],
        alpha: 1,
        hex: "#0000FF"
    )
    public static let darkBlue = ColorValue(
        colorSpace: .srgb,
        components: [0, 0, 0.6],
        alpha: 1,
        hex: "#000099"
    )
    public static let green = ColorValue(
        colorSpace: .srgb,
        components: [0, 1, 0],
        alpha: 1,
        hex: "#00FF00"
    )
    public static let darkGreen = ColorValue(
        colorSpace: .srgb,
        components: [0, 0.6, 0],
        alpha: 1,
        hex: "#009900"
    )
    public static let yellow = ColorValue(
        colorSpace: .srgb,
        components: [1, 1, 0],
        alpha: 1,
        hex: "#FFFF00"
    )
    public static let darkYellow = ColorValue(
        colorSpace: .srgb,
        components: [0.8, 0.8, 0],
        alpha: 1,
        hex: "#CCCC00"
    )
    public static let gray = ColorValue(
        colorSpace: .srgb,
        components: [0.5, 0.5, 0.5],
        alpha: 1,
        hex: "#808080"
    )
    public static let darkGray = ColorValue(
        colorSpace: .srgb,
        components: [0.3, 0.3, 0.3],
        alpha: 1,
        hex: "#4C4C4C"
    )
    public static let black = ColorValue(
        colorSpace: .srgb,
        components: [0, 0, 0],
        alpha: 1,
        hex: "#000000"
    )
    public static let white = ColorValue(
        colorSpace: .srgb,
        components: [1, 1, 1],
        alpha: 1,
        hex: "#FFFFFF"
    )
    public static let brown = ColorValue(
        colorSpace: .srgb,
        components: [0.65, 0.16, 0.16],
        alpha: 1,
        hex: "#A62929"
    )
}

extension DimensionValue {
    public static let tenPixels = DimensionValue(value: 10, unit: .px)
    public static let twoREM = DimensionValue(value: 2, unit: .rem)
}

extension TokenValue {
    public static let reddishColor: TokenValue = .color(.reddish)
    public static let smallSpacing: TokenValue = .dimension(.twoREM)
}
