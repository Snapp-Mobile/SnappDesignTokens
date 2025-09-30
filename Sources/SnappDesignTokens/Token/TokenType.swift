//
//  TokenType.swift
//
//  Created by Volodymyr Voiko on 18.03.2025.
//

import Foundation

/// Represents a design token type identifier as defined by the DTCG specification.
///
/// Token types ensure tools can reliably interpret token values and provide validation.
/// The type can be set directly on a token, inherited from a parent group, or determined
/// by a referenced token's type.
///
/// Example:
/// ```swift
/// let colorType = TokenType.color
/// let customType = TokenType(rawValue: "customType")
/// ```
public struct TokenType: RawRepresentable, Codable, Sendable, Equatable, Hashable {
    /// String identifier for the token type.
    public let rawValue: String

    /// Creates a token type with the specified identifier.
    ///
    /// - Parameter rawValue: String identifier for the token type
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(from decoder: any Decoder) throws {
        self.rawValue = try .init(from: decoder)
    }
}

extension TokenType {
    /// Represents a color in the UI.
    public static let color = Self(rawValue: "color")

    /// Represents distance values (width, height, position).
    public static let dimension = Self(rawValue: "dimension")

    /// Represents file references.
    public static let file = Self(rawValue: "file")

    /// Represents font family names.
    public static let fontFamily = Self(rawValue: "fontFamily")

    /// Represents font weight (thickness).
    public static let fontWeight = Self(rawValue: "fontWeight")

    /// Represents numeric values without units.
    public static let number = Self(rawValue: "number")

    /// Represents time duration for animations.
    public static let duration = Self(rawValue: "duration")

    /// Represents animation timing/progression curves.
    public static let cubicBezier = Self(rawValue: "cubicBezier")

    /// Represents complete text styling properties.
    public static let typography = Self(rawValue: "typography")

    /// Represents color gradient definitions.
    public static let gradient = Self(rawValue: "gradient")

    /// Represents shadow effect properties.
    public static let shadow = Self(rawValue: "shadow")

    /// Represents line and border style properties.
    public static let strokeStyle = Self(rawValue: "strokeStyle")

    /// Represents border properties (color, width, style).
    public static let border = Self(rawValue: "border")

    /// Represents animated state transitions.
    public static let transition = Self(rawValue: "transition")
}
