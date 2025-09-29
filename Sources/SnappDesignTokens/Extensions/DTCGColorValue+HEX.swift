//
//  ColorValue+HEX.swift
//
//  Created by Volodymyr Voiko on 14.05.2025.
//

import Foundation

public enum ColorValueHexDecodingError: Error, Equatable, Sendable {
    case invalidHEX(String)
}

public enum ColorValueHexEncodingError: Error, Equatable, Sendable {
    case unsupportedColorSpace(TokenColorSpace)
    case invalidComponents([ColorComponent])
}

public enum ColorHexFormat: Equatable, Sendable {
    public static let `default`: ColorHexFormat = .rgba

    case argb
    case rgba
}

extension ColorValue {
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
