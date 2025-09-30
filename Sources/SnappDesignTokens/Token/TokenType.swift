//
//  TokenType.swift
//
//  Created by Volodymyr Voiko on 18.03.2025.
//

import Foundation

public struct TokenType: RawRepresentable, Codable, Sendable, Equatable, Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(from decoder: any Decoder) throws {
        self.rawValue = try .init(from: decoder)
    }
}

extension TokenType {
    public static let color = Self(rawValue: "color")
    public static let dimension = Self(rawValue: "dimension")
    public static let file = Self(rawValue: "file")
    public static let fontFamily = Self(rawValue: "fontFamily")
    public static let fontWeight = Self(rawValue: "fontWeight")
    public static let number = Self(rawValue: "number")
    public static let typography = Self(rawValue: "typography")
    public static let gradient = Self(rawValue: "gradient")
    public static let duration = Self(rawValue: "duration")
    public static let shadow = Self(rawValue: "shadow")
    public static let strokeStyle = Self(rawValue: "strokeStyle")
    public static let border = Self(rawValue: "border")
    public static let cubicBezier = Self(rawValue: "cubicBezier")
    public static let transition = Self(rawValue: "transition")
}
