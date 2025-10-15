//
//  ColorValue.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
// Reason: Documentation is in `Color.md`
public struct ColorValue: Codable, EncodableWithConfiguration, Equatable,
    Sendable
{
    private enum CodingKeys: CodingKey {
        case colorSpace
        case components
        case alpha
        case hex
    }

    /// Color space defining how component values are interpreted.
    ///
    /// Determines the gamut and interpretation of ``components``. See ``TokenColorSpace``
    /// for supported color spaces including sRGB, Display P3, HSL, Lab, and more.
    public let colorSpace: TokenColorSpace

    /// Array of color component values for the specified color space.
    ///
    /// Number and interpretation of components depends on ``colorSpace``:
    /// - RGB spaces (sRGB, Display P3, etc.): `[red, green, blue]`
    /// - HSL: `[hue, saturation, lightness]`
    /// - Lab/Oklab: `[lightness, a, b]`
    /// - LCH/Oklch: `[lightness, chroma, hue]`
    ///
    /// Components can be ``ColorComponent/value(_:)`` or ``ColorComponent/none`` for
    /// missing/undefined channels.
    public let components: [ColorComponent]

    /// Opacity value from 0.0 (fully transparent) to 1.0 (fully opaque).
    ///
    /// Per DTCG specification, defaults to 1.0 (fully opaque) when not specified.
    public let alpha: Double

    /// Optional hex string using CSS notation (e.g., `"#FF0000"`).
    ///
    /// For sRGB colors or closest sRGB approximation for other color spaces.
    /// Preserved during round-trip encoding/decoding.
    public let hex: String?

    /// Creates a color value with the specified color space and components.
    ///
    /// - Parameters:
    ///   - colorSpace: Color space defining component interpretation
    ///   - components: Array of color component values
    ///   - alpha: Opacity (0.0-1.0), defaults to 1.0
    ///   - hex: Optional hex string representation
    public init(
        colorSpace: TokenColorSpace,
        components: [ColorComponent],
        alpha: Double? = nil,
        hex: String? = nil
    ) {
        self.colorSpace = colorSpace
        self.components = components
        self.alpha = alpha ?? 1.0
        self.hex = hex
    }

    /// Decodes a color from structured format or hex string.
    ///
    /// Attempts structured decoding first (color space + components), falling back
    /// to hex string format.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: `DecodingError` if format is invalid or hex string is malformed
    public init(from decoder: any Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.init(
                colorSpace: try container.decode(
                    TokenColorSpace.self,
                    forKey: .colorSpace
                ),
                components: try container.decode(
                    [ColorComponent].self,
                    forKey: .components
                ),
                alpha: try container.decodeIfPresent(
                    Double.self,
                    forKey: .alpha
                ),
                hex: try container.decodeIfPresent(String.self, forKey: .hex)
            )
        } catch {
            let container = try decoder.singleValueContainer()
            let hexString = try container.decode(String.self)
            do {
                try self.init(hex: hexString)
            } catch {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription:
                            "Invalid hex string format. Received: \(hexString)",
                        underlyingError: error
                    )
                )
            }
        }

    }

    /// Encodes the color value using the encoder's configuration.
    ///
    /// - Parameter encoder: Encoder to write data to
    /// - Throws: Error if encoding fails
    public func encode(to encoder: any Encoder) throws {
        try self.encode(
            to: encoder,
            configuration: encoder.tokenEncodingConfiguration
                .tokenValueEncodingConfiguration?.colorEncodingConfiguration
                ?? .default
        )
    }

    /// Encodes the color value with the specified configuration.
    ///
    /// - Parameters:
    ///   - encoder: Encoder to write data to
    ///   - configuration: Encoding format (`.default` for structured, `.hex` for hex string)
    /// - Throws: Error if encoding fails
    public func encode(
        to encoder: any Encoder,
        configuration: ColorValueEncodingConfiguration
    ) throws {
        switch configuration {
        case .default:
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.colorSpace, forKey: .colorSpace)
            try container.encode(self.components, forKey: .components)
            try container.encode(self.alpha, forKey: .alpha)
            try container.encodeIfPresent(self.hex, forKey: .hex)
        case .hex:
            try hex(
                format: .rgba,
                skipFullOpacityAlpha: true
            ).encode(to: encoder)
        }
    }
}
