//
//  TokenGroup.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

/// A collection of design tokens organized hierarchically.
///
/// Groups provide organizational structure for tokens and support type inheritance.
/// Child tokens inherit the `$type` property from their parent group if not explicitly set.
///
/// ### Example
/// ```swift
/// let group: TokenGroup = [
///     "primary": .value(.color(.red)),
///     "spacing": .group([
///         "small": .value(.dimension(.constant(.init(value: 8, unit: .px))))
///     ])
/// ]
/// ```
public typealias TokenGroup = [String: Token]

extension TokenGroup {
    /// Decodes a token group using the parent configuration.
    ///
    /// Reads the optional `$type` property and passes it to child tokens for type inheritance.
    /// All keys except `$type` are decoded as tokens within the group.
    ///
    /// - Parameters:
    ///   - decoder: Decoder to read data from
    ///   - configuration: Parent configuration including inherited type and custom mappings
    /// - Throws: `DecodingError` if group structure is invalid
    init(
        from decoder: any Decoder,
        parentConfiguration configuration: TokenDecodingConfiguration
    ) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        let groupType = try container.decodeIfPresent(
            TokenType.self,
            forKey: .type
        )

        var tokenConfiguration = configuration
        if let groupType {
            tokenConfiguration.parentType = groupType
        }

        let uniqueKeysWithValues: [(String, Token)] = try container.allKeys.compactMap { key in
            guard key != .type else { return nil }
            let token = try container.decode(
                Token.self,
                forKey: key,
                configuration: tokenConfiguration
            )
            return (key.stringValue, token)
        }
        self.init(uniqueKeysWithValues: uniqueKeysWithValues)
    }
}

extension DynamicCodingKey {
    fileprivate static let type = Self(stringValue: Token.CodingKeys.type.stringValue)
}
