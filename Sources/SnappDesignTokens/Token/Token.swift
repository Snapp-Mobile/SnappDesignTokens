//
//  Token.swift
//
//  Created by Volodymyr Voiko on 03.03.2025.
//

import Foundation
import OSLog

public enum Token: DecodableWithConfiguration, Decodable,
    Encodable, EncodableWithConfiguration, Equatable, Sendable
{
    public static let unknown: Self = .unknown(UnknownToken(rawValue: nil))

    case value(TokenValue)
    case group(TokenGroup)
    case alias(TokenPath)
    case unknown(UnknownToken)
    case array(TokenArray)

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case value = "$value"
    }

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
