//
//  ColorValue+HEX.swift
//
//  Created by Volodymyr Voiko on 14.05.2025.
//

import Foundation

/// Error thrown when decoding an invalid hex color string.
public enum ColorValueHexDecodingError: Error, Equatable, Sendable {
    /// Hex string format is invalid (must be #RRGGBB or #RRGGBBAA).
    case invalidHEX(String)
}

/// Error thrown when encoding a color value to hex format.
public enum ColorValueHexEncodingError: Error, Equatable, Sendable {
    /// Color space is not sRGB (only sRGB supports hex encoding).
    case unsupportedColorSpace(TokenColorSpace)

    /// One or more components use "none" keyword instead of numeric values.
    case invalidComponents([ColorComponent])
}

/// Hex color string format for alpha channel placement.
public enum ColorHexFormat: Equatable, Sendable {
    /// Default format (RGBA).
    public static let `default`: ColorHexFormat = .rgba

    /// Alpha-Red-Green-Blue format (#AARRGGBB).
    case argb

    /// Red-Green-Blue-Alpha format (#RRGGBBAA).
    case rgba
}

extension ColorValue {
    /// Creates a color from a hex string.
    ///
    /// Parses hex color strings in #RRGGBB or #RRGGBBAA format (6 or 8 hex digits).
    /// Resulting color uses sRGB color space. Alpha defaults to 1.0 for 6-digit format.
    ///
    /// ### Example
    /// ```swift
    /// let red = try ColorValue(hex: "#FF0000")
    /// let semiTransparent = try ColorValue(hex: "#FF0000FF")
    /// ```
    ///
    /// - Parameter hexString: Hex color string starting with #
    /// - Throws: ``ColorValueHexDecodingError/invalidHEX(_:)`` if format is invalid
    public init(hex hexString: String) throws {
        guard hexString.hasPrefix("#") else {
            throw ColorValueHexDecodingError.invalidHEX(hexString)
        }

        let cleanHex = hexString.trimmingCharacters(in: .whitespaces)
            .dropFirst()

        guard
            cleanHex.count == 6 || cleanHex.count == 8,
            let hexValue = Int(cleanHex, radix: 16)
        else {
            throw ColorValueHexDecodingError.invalidHEX(hexString)
        }

        var components = [Double]()
        for offset in 1...cleanHex.count / 2 {
            components.insert(
                Double((hexValue >> (8 * offset - 8)) & 0xFF) / 255.0,
                at: components.startIndex
            )
        }

        if components.count == 3 {
            components.append(1.0)
        }

        self.init(
            colorSpace: .srgb,
            components: [
                .value(components[0]),
                .value(components[1]),
                .value(components[2]),
            ],
            alpha: components[3],
            hex: "#" + cleanHex
        )
    }

    /// Converts color to hex string representation.
    ///
    /// Only sRGB colors with numeric components can be converted to hex format.
    ///
    /// ### Example
    /// ```swift
    /// let hex = try ColorValue.red.hex()  // "#FF0000"
    /// let argb = try ColorValue.red.hex(format: .argb)  // "#FFFF0000"
    /// ```
    ///
    /// - Parameters:
    ///   - format: Alpha channel placement (default: ``ColorHexFormat/rgba``)
    ///   - skipFullOpacityAlpha: Omit alpha when fully opaque (default: `false`)
    /// - Returns: Hex color string
    /// - Throws: ``ColorValueHexEncodingError`` if color space is not sRGB or components contain "none"
    public func hex(
        format: ColorHexFormat = .default,
        skipFullOpacityAlpha: Bool = false
    ) throws -> String {
        guard colorSpace == .srgb else {
            throw ColorValueHexEncodingError.unsupportedColorSpace(
                colorSpace
            )
        }

        guard
            case .value(let red) = components[0],
            case .value(let green) = components[1],
            case .value(let blue) = components[2]
        else {
            throw ColorValueHexEncodingError.invalidComponents(components)
        }

        let r = Int(round(red * 255))
        let g = Int(round(green * 255))
        let b = Int(round(blue * 255))
        let a = Int(round(alpha * 255))

        return switch (a, format) {
        case (255, _) where skipFullOpacityAlpha:
            String(format: "#%02X%02X%02X", r, g, b)
        case (_, .rgba):
            String(format: "#%02X%02X%02X%02X", r, g, b, a)
        case (_, .argb):
            String(format: "#%02X%02X%02X%02X", a, r, g, b)
        }
    }
}
