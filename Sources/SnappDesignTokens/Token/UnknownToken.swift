//
//  UnknownToken.swift
//
//  Created by Volodymyr Voiko on 19.03.2025.
//

import Foundation

/// Represents a token that cannot be decoded as a valid DTCG token type.
///
/// Used as a fallback when parsing encounters data that doesn't match any known token
/// structure. Preserves the raw value to maintain round-trip encoding fidelity.
///
/// Examples:
/// ```swift
/// // String values
/// let token: Token = .unknown("metadata-value")
///
/// // Null or invalid values
/// let token: Token = .unknown
///
/// // From string literal
/// let unknown: UnknownToken = "custom-value"
/// ```
public struct UnknownToken: RawRepresentable, Codable, Equatable, Sendable, ExpressibleByStringLiteral {
    /// Raw string value of the unknown token, or `nil` for null/empty values.
    public let rawValue: String?

    /// Creates an unknown token with the specified raw value.
    ///
    /// - Parameter rawValue: Raw string value, or `nil` for null/empty tokens
    public init(rawValue: String?) {
        self.rawValue = rawValue
    }

    /// Creates an unknown token from a string literal.
    ///
    /// - Parameter value: String literal value
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }

    public init(from decoder: any Decoder) throws {
        self.init(rawValue: try? String(from: decoder))
    }
}
