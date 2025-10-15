//
//  TokenGroup.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
// Reason: Documentation is in `Group.md`
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
