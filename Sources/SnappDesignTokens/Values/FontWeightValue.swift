//
//  FontWeightValue.swift
//
//  Created by Volodymyr Voiko on 27.03.2025.
//

import Foundation

public enum FontWeightValueDecodingError: Error, Equatable {
    case invalidValue(UInt)
    case invalidAlias(String)
}

public struct FontWeightValue: RawRepresentable, Codable, Equatable,
    Sendable
{
    private static let validRange: ClosedRange<UInt> = 1...1000

    public enum Alias: String, CaseIterable, Equatable, Sendable {
        case thin, hairline
        case extraLight = "extra-light"
        case ultraLight = "ultra-light"
        case light
        case normal, regular, book
        case medium
        case semibold = "semi-bold"
        case demibold = "demi-bold"
        case bold
        case extraBold = "extra-bold"
        case ultraBold = "ultra-bold"
        case black, heavy
        case extraBlack = "extra-black"
        case ultraBlack = "ultra-black"
    }

    public let rawValue: UInt
    private let alias: Alias?

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

    public init?(rawValue: UInt) {
        guard Self.validRange.contains(rawValue) else { return nil }
        self.rawValue = rawValue
        self.alias = nil
    }

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
                    rawStringValue)
            }
            self.init(alias: alias)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        if let alias {
            try alias.rawValue.encode(to: encoder)
        } else {
            try rawValue.encode(to: encoder)
        }
    }
}

// MARK: - CompositeTokenValue+Alias -

extension CompositeTokenValue where Value == FontWeightValue {
    public static func value(_ alias: Value.Alias) -> Self {
        .value(FontWeightValue(alias: alias))
    }
}
