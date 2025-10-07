//
//  Token.swift
//
//  Created by Volodymyr Voiko on 03.03.2025.
//

import Foundation
import OSLog

/// Represents a design token as defined by the DTCG specification.
///
/// A token is the core data structure for design system information. Tokens can represent
/// concrete values, hierarchical groups, references to other tokens, arrays, or unknown data.
///
/// Example:
/// ```swift
/// // Value token
/// let token: Token = .value(.color(.red))
///
/// // Group token with nested structure
/// let token: Token = .group([
///     "primary": .value(.color(.red)),
///     "spacing": .group([
///         "small": .value(.dimension(.constant(.init(value: 8, unit: .px))))
///     ])
/// ])
///
/// // Alias token referencing another token
/// let token: Token = .alias(TokenPath("color", "primary"))
///
/// // Array token
/// let token: Token = .array([.unknown("metadata")])
/// ```
public enum Token: DecodableWithConfiguration, Decodable,
    Encodable, EncodableWithConfiguration, Equatable, Sendable
{
    /// Represents an unknown or null token value.
    public static let unknown: Self = .unknown(UnknownToken(rawValue: nil))

    /// Token with a concrete value (color, dimension, etc.).
    case value(TokenValue)

    /// Token group containing nested tokens.
    case group(TokenGroup)

    /// Token alias referencing another token's value.
    case alias(TokenPath)

    /// Unknown or invalid token that preserves raw data.
    case unknown(UnknownToken)

    /// Array of tokens.
    case array(TokenArray)

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case value = "$value"
    }

    /// Decodes a token using the specified configuration.
    ///
    /// Attempts to decode in order: value token (with `$value` key), array, group, or unknown.
    /// Type information is inherited from parent groups or custom type mappings.
    ///
    /// - Parameters:
    ///   - decoder: Decoder to read data from
    ///   - configuration: Configuration including parent type and custom mappings
    /// - Throws: `DecodingError` if decoding fails
    public init(
        from decoder: any Decoder,
        configuration: TokenDecodingConfiguration
    ) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self),
            container.contains(.value)
        {
            let tokenType = try container.decodeIfPresent(
                TokenType.self,
                forKey: .type
            )

            let type = tokenType ?? configuration.parentType
            let valueConfiguration = TokenValueDecodingConfiguration(
                type: type,
                file: configuration.fileDecodingConfiguration,
                customTypeMapping: configuration.customTypeMapping
            )
            if let path = try? container.decode(
                TokenPath.self,
                forKey: .value
            ) {
                self = .alias(path)
            } else if let value = try? container.decode(
                TokenValue.self,
                forKey: .value,
                configuration: valueConfiguration
            ) {
                self = .value(value)
            } else {
                let unknownToken = try container.decode(
                    UnknownToken.self,
                    forKey: .value
                )
                self = .unknown(unknownToken)
            }
        } else if let array = try? TokenArray(
            from: decoder,
            parentConfiguration: configuration
        ) {
            self = .array(array)
        } else if let group = try? TokenGroup(
            from: decoder,
            parentConfiguration: configuration
        ) {
            self = .group(group)
        } else {
            let unknownToken = try UnknownToken(from: decoder)
            self = .unknown(unknownToken)
        }
    }

    public init(from decoder: any Decoder) throws {
        try self.init(
            from: decoder,
            configuration: decoder.tokenDecodingConfiguration
        )
    }

    public func encode(to encoder: any Encoder) throws {
        try self.encode(
            to: encoder,
            configuration: encoder.tokenEncodingConfiguration
        )
    }

    /// Encodes the token using the specified configuration.
    ///
    /// - Parameters:
    ///   - encoder: Encoder to write data to
    ///   - configuration: Configuration specifying encoding options
    /// - Throws: Error if encoding fails
    public func encode(
        to encoder: any Encoder,
        configuration: TokenEncodingConfiguration
    ) throws {
        switch self {
        case .value(let value):
            do {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(value.tokenType, forKey: .type)
                try container.encode(value, forKey: .value)
            } catch {
                try value.encode(to: encoder)
            }
        case .unknown(let token):
            try token.rawValue.encode(to: encoder)
        case .group(let group):
            try group.encode(to: encoder)
        case .array(let array):
            try array.encode(to: encoder)
        case .alias(let path):
            try path.encode(to: encoder)
        }
    }
}
