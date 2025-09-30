//
//  ColorValue.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

public struct ColorValue: Codable, EncodableWithConfiguration, Equatable,
    Sendable
{
    private enum CodingKeys: CodingKey {
        case colorSpace
        case components
        case alpha
        case hex
    }

    public let colorSpace: TokenColorSpace
    public let components: [ColorComponent]
    public let alpha: Double
    public let hex: String?

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

    public func encode(to encoder: any Encoder) throws {
        try self.encode(
            to: encoder,
            configuration: encoder.tokenEncodingConfiguration
                .tokenValueEncodingConfiguration?.colorEncodingConfiguration
                ?? .default
        )
    }

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
