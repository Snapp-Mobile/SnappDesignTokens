//
//  TokenCollection.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import Foundation

/// Represents a collection of token values that can be encoded as a single value or array.
///
/// Generic wrapper supporting DTCG tokens that may contain either a single value or multiple
/// values. Automatically handles encoding/decoding between single value and array representations.
///
/// ### Example
/// ```swift
/// // Single value
/// let single = TokenCollection(values: [.red])  // Encodes as "#FF0000"
///
/// // Multiple values
/// let multiple = TokenCollection(values: [.red, .green, .blue])  // Encodes as array
/// ```
public struct TokenCollection<Value> {
    /// Array of token values.
    public let values: [Value]

    /// Creates a token collection with the specified values.
    ///
    /// - Parameter values: Array of token values
    public init(values: [Value]) {
        self.values = values
    }
}

extension TokenCollection: Equatable where Value: Equatable {}

extension TokenCollection: Sendable where Value: Sendable {}

extension TokenCollection: Decodable where Value: Decodable {
    /// Decodes a single value or array of values.
    ///
    /// Attempts array decoding first, falling back to single value if array decoding fails.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: `DecodingError` if value cannot be decoded as either array or single value
    public init(from decoder: any Decoder) throws {
        do {
            self.values = try [Value](from: decoder)
        } catch {
            self.values = [try Value(from: decoder)]
        }
    }
}

extension TokenCollection: Encodable where Value: Encodable {
    /// Encodes as single value or array based on count.
    ///
    /// Encodes single-element collections as unwrapped value, multi-element as array.
    ///
    /// - Parameter encoder: Encoder to write data to
    /// - Throws: `EncodingError.invalidValue` if encoding fails
    public func encode(to encoder: any Encoder) throws {
        if values.count == 1 {
            try values[0].encode(to: encoder)
        } else {
            try values.encode(to: encoder)
        }
    }
}

extension TokenCollection: CompositeToken where Value: CompositeToken {
    /// Resolves all token aliases in the collection.
    ///
    /// Traverses each value to resolve any `{group.token}` references.
    ///
    /// - Parameter root: Root token containing the complete token tree for lookups
    /// - Throws: Error if any alias cannot be resolved or type mismatch occurs
    public mutating func resolveAliases(root: Token) throws {
        var values = values
        try values.resolveAliases(root: root)
        self = .init(values: values)
    }
}
