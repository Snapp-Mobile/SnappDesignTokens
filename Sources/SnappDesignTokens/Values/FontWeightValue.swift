//
//  FontWeightValue.swift
//
//  Created by Volodymyr Voiko on 27.03.2025.
//

import Foundation

/// Error thrown when decoding an invalid font weight.
public enum FontWeightValueDecodingError: Error, Equatable {
    /// Numeric value is outside the valid range (1-1000).
    case invalidValue(UInt)

    /// String is not a recognized weight alias.
    case invalidAlias(String)
}

// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
// Reason: Documentation is in `FontWeight.md`
public struct FontWeightValue: RawRepresentable, Codable, Equatable, Sendable {
    private static let validRange: ClosedRange<UInt> = 1...1000

    /// Named aliases for common font weights.
    ///
    /// DTCG-defined keywords mapping to specific numeric values. Case-sensitive.
    public enum Alias: String, CaseIterable, Equatable, Sendable {
        /// Thin weight (100).
        case thin, hairline

        /// Extra light weight (200).
        case extraLight = "extra-light"

        /// Ultra light weight (200).
        case ultraLight = "ultra-light"

        /// Light weight (300).
        case light

        /// Normal/regular weight (400).
        case normal, regular, book

        /// Medium weight (500).
        case medium

        /// Semi-bold weight (600).
        case semibold = "semi-bold"

        /// Demi-bold weight (600).
        case demibold = "demi-bold"

        /// Bold weight (700).
        case bold

        /// Extra bold weight (800).
        case extraBold = "extra-bold"

        /// Ultra bold weight (800).
        case ultraBold = "ultra-bold"

        /// Black/heavy weight (900).
        case black, heavy

        /// Extra black weight (1000).
        case extraBlack = "extra-black"

        /// Ultra black weight (1000).
        case ultraBlack = "ultra-black"
    }

    /// Numeric weight value (1-1000).
    public let rawValue: UInt

    private let alias: Alias?

    /// Creates a font weight from a named alias.
    ///
    /// Maps the alias to its corresponding numeric value per DTCG specification.
    ///
    /// - Parameter alias: Named weight alias
    public init(alias: Alias) {
        rawValue =
            switch alias {
            case .thin, .hairline:
                100
            case .extraLight, .ultraLight:
                200
            case .light:
                300
            case .normal, .regular, .book:
                400
            case .medium:
                500
            case .semibold, .demibold:
                600
            case .bold:
                700
            case .extraBold, .ultraBold:
                800
            case .black, .heavy:
                900
            case .extraBlack, .ultraBlack:
                1000
            }
        self.alias = alias
    }

    /// Creates a font weight from a numeric value.
    ///
    /// - Parameter rawValue: Weight value (must be 1-1000)
    /// - Returns: Font weight, or `nil` if value is out of range
    public init?(rawValue: UInt) {
        guard Self.validRange.contains(rawValue) else { return nil }
        self.rawValue = rawValue
        self.alias = nil
    }

    /// Decodes a font weight from numeric value or alias string.
    ///
    /// Attempts numeric decoding first, falling back to alias lookup.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: `DecodingError` if value is neither number nor string, ``FontWeightValueDecodingError`` if value/alias is invalid
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let rawValue = try? container.decode(UInt.self) {
            guard let value = Self(rawValue: rawValue) else {
                throw FontWeightValueDecodingError.invalidValue(rawValue)
            }
            self = value
        } else {
            let rawStringValue = try container.decode(String.self)
            guard let alias = Alias(rawValue: rawStringValue) else {
                throw FontWeightValueDecodingError.invalidAlias(
                    rawStringValue
                )
            }
            self.init(alias: alias)
        }
    }

    /// Encodes as alias string or numeric value.
    ///
    /// Encodes as original format: alias if created from alias, number otherwise.
    ///
    /// - Parameter encoder: Encoder to write data to
    /// - Throws: Error if encoding fails
    public func encode(to encoder: any Encoder) throws {
        if let alias {
            try alias.rawValue.encode(to: encoder)
        } else {
            try rawValue.encode(to: encoder)
        }
    }
}

extension CompositeTokenValue where Value == FontWeightValue {
    /// Creates a composite token value from a font weight alias.
    ///
    /// Convenience method for creating font weight values in composite tokens.
    ///
    /// - Parameter alias: Font weight alias
    /// - Returns: Composite token value wrapping the font weight
    public static func value(_ alias: Value.Alias) -> Self {
        .value(FontWeightValue(alias: alias))
    }
}
