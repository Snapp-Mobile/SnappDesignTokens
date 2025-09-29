//
//  CompositeTokenValue.swift
//
//  Created by Volodymyr Voiko on 25.03.2025.
//

import Foundation

public enum CompositeTokenValue<Value>: Codable, Equatable, Sendable
where Value: Codable, Value: Equatable, Value: Sendable {
    case alias(TokenPath)
    case value(Value)

    public init(from decoder: any Decoder)
        throws
    {
        do {
            let path = try TokenPath(from: decoder)
            self = .alias(path)
        } catch {
            let value = try Value(from: decoder)
            self = .value(value)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .alias(let path):
            try path.encode(to: encoder)
        case .value(let value):
            try value.encode(to: encoder)
        }
    }
}
