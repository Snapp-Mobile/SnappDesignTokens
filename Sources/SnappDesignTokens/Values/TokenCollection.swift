//
//  TokenCollection.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import Foundation

public struct TokenCollection<Value> {
    public let values: [Value]

    public init(values: [Value]) {
        self.values = values
    }
}

extension TokenCollection: Equatable where Value: Equatable {}

extension TokenCollection: Sendable where Value: Sendable {}

extension TokenCollection: Decodable where Value: Decodable {
    public init(from decoder: any Decoder) throws {
        do {
            self.values = try [Value](from: decoder)
        } catch {
            self.values = [try Value(from: decoder)]
        }
    }
}

extension TokenCollection: Encodable where Value: Encodable {
    public func encode(to encoder: any Encoder) throws {
        if values.count == 1 {
            try values[0].encode(to: encoder)
        } else {
            try values.encode(to: encoder)
        }
    }
}

extension TokenCollection: CompositeToken where Value: CompositeToken {
    public mutating func resolveAliases(root: Token) throws {
        var values = values
        try values.resolveAliases(root: root)
        self = .init(values: values)
    }
}
