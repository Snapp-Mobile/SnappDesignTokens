//
//  ColorValue+Color.swift
//
//  Created by Oleksii Kolomiiets on 10/1/25.
//

import Foundation

/// Convenience constants for common color values.
///
/// Provides shorthand access to frequently used colors, eliminating the need
/// to specify color space, components, and hex values manually. Use `.red`
/// instead of constructing full ``ColorValue`` instances.
///
/// Example:
/// ```swift
/// // Without helpers:
/// let color = ColorValue(colorSpace: .srgb, components: [1, 0, 0], alpha: 1, hex: "#FF0000")
///
/// // With helpers:
/// let color = ColorValue.red
/// ```
///
/// Extend with custom colors following the same pattern:
/// ```swift
/// extension ColorValue {
///     public static let brandPrimary = ColorValue(
///         colorSpace: .srgb,
///         components: [0.2, 0.4, 0.8],
///         alpha: 1,
///         hex: "#3366CC"
///     )
/// }
/// ```
extension ColorValue {
    // MARK: - Primary Colors

    /// Pure red color in sRGB (`#FF0000`).
    public static let red = ColorValue(
        colorSpace: .srgb,
        components: [1, 0, 0],
        alpha: 1,
        hex: "#FF0000"
    )

    /// Semi-transparent red color in sRGB (`#FF0000` at 20% opacity).
    public static let reddish = ColorValue(
        colorSpace: .srgb,
        components: [1, 0, 0],
        alpha: 0.2,
        hex: "#FF0000"
    )

    /// Pure blue color in sRGB (`#0000FF`).
    public static let blue = ColorValue(
        colorSpace: .srgb,
        components: [0, 0, 1],
        alpha: 1,
        hex: "#0000FF"
    )

    /// Dark blue color in sRGB (`#000099`).
    public static let darkBlue = ColorValue(
        colorSpace: .srgb,
        components: [0, 0, 0.6],
        alpha: 1,
        hex: "#000099"
    )

    /// Pure green color in sRGB (`#00FF00`).
    public static let green = ColorValue(
        colorSpace: .srgb,
        components: [0, 1, 0],
        alpha: 1,
        hex: "#00FF00"
    )

    /// Dark green color in sRGB (`#009900`).
    public static let darkGreen = ColorValue(
        colorSpace: .srgb,
        components: [0, 0.6, 0],
        alpha: 1,
        hex: "#009900"
    )

    // MARK: - Secondary Colors

    /// Pure yellow color in sRGB (`#FFFF00`).
    public static let yellow = ColorValue(
        colorSpace: .srgb,
        components: [1, 1, 0],
        alpha: 1,
        hex: "#FFFF00"
    )

    /// Dark yellow color in sRGB (`#CCCC00`).
    public static let darkYellow = ColorValue(
        colorSpace: .srgb,
        components: [0.8, 0.8, 0],
        alpha: 1,
        hex: "#CCCC00"
    )

    /// Pure cyan color in sRGB (`#00FFFF`).
    public static let cyan = ColorValue(
        colorSpace: .srgb,
        components: [0, 1, 1],
        alpha: 1,
        hex: "#00FFFF"
    )

    /// Pure magenta color in sRGB (`#FF00FF`).
    public static let magenta = ColorValue(
        colorSpace: .srgb,
        components: [1, 0, 1],
        alpha: 1,
        hex: "#FF00FF"
    )

    // MARK: - Grayscale

    /// Pure black color in sRGB (`#000000`).
    public static let black = ColorValue(
        colorSpace: .srgb,
        components: [0, 0, 0],
        alpha: 1,
        hex: "#000000"
    )

    /// Pure white color in sRGB (`#FFFFFF`).
    public static let white = ColorValue(
        colorSpace: .srgb,
        components: [1, 1, 1],
        alpha: 1,
        hex: "#FFFFFF"
    )

    /// Medium gray color in sRGB (`#808080`).
    public static let gray = ColorValue(
        colorSpace: .srgb,
        components: [0.5, 0.5, 0.5],
        alpha: 1,
        hex: "#808080"
    )

    /// Dark gray color in sRGB (`#4C4C4C`).
    public static let darkGray = ColorValue(
        colorSpace: .srgb,
        components: [0.3, 0.3, 0.3],
        alpha: 1,
        hex: "#4C4C4C"
    )

    /// Light gray color in sRGB (`#CCCCCC`).
    public static let lightGray = ColorValue(
        colorSpace: .srgb,
        components: [0.8, 0.8, 0.8],
        alpha: 1,
        hex: "#CCCCCC"
    )

    // MARK: - Additional Colors

    /// Brown color in sRGB (`#A62929`).
    public static let brown = ColorValue(
        colorSpace: .srgb,
        components: [0.65, 0.16, 0.16],
        alpha: 1,
        hex: "#A62929"
    )

    /// Orange color in sRGB (`#FF8000`).
    public static let orange = ColorValue(
        colorSpace: .srgb,
        components: [1, 0.5, 0],
        alpha: 1,
        hex: "#FF8000"
    )

    /// Purple color in sRGB (`#8000FF`).
    public static let purple = ColorValue(
        colorSpace: .srgb,
        components: [0.5, 0, 1],
        alpha: 1,
        hex: "#8000FF"
    )

    /// Pink color in sRGB (`#FF80FF`).
    public static let pink = ColorValue(
        colorSpace: .srgb,
        components: [1, 0.5, 1],
        alpha: 1,
        hex: "#FF80FF"
    )

    /// Transparent color (fully transparent white).
    public static let clear = ColorValue(
        colorSpace: .srgb,
        components: [1, 1, 1],
        alpha: 0,
        hex: "#FFFFFF"
    )
}
