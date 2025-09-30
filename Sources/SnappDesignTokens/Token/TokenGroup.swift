//
//  TokenGroup.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

public typealias TokenGroup = [String: Token]

extension TokenGroup {
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
