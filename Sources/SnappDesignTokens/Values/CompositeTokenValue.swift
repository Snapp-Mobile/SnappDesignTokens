//
//  CompositeTokenValue.swift
//
//  Created by Volodymyr Voiko on 25.03.2025.
//

import Foundation

/// Represents a sub-value within a composite token that can be a direct value or alias.
///
/// DTCG composite tokens like Border, Shadow, and Typography combine multiple sub-values.
/// Each sub-value can be either an explicit value or a reference to another token using
/// `{group.token}` syntax. This type provides the wrapper for that flexibility.
///
/// Example:
/// ```swift
/// // Direct value
/// let color: CompositeTokenValue<ColorValue> = .value(.red)
///
/// // Token alias
/// let width: CompositeTokenValue<DimensionValue> = .alias(
///     TokenPath("spacing", "medium")
/// )
/// ```
public enum CompositeTokenValue<Value>: Codable, Equatable, Sendable
where Value: Codable, Value: Equatable, Value: Sendable {
    /// Token alias referencing another token's value.
    ///
    /// Contains a ``TokenPath`` in `{group.token}` format. Must be resolved to
    /// access the actual value.
    case alias(TokenPath)

    /// Direct value of the specified type.
    case value(Value)

    /// Decodes a composite token sub-value as alias or direct value.
    ///
    /// Attempts to decode as ``TokenPath`` first (alias), falling back to direct value.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: `DecodingError` if neither alias nor value decoding succeeds
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

    /// Encodes the alias or direct value.
    ///
    /// - Parameter encoder: Encoder to write data to
    /// - Throws: Error if encoding fails
    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .alias(let path):
            try path.encode(to: encoder)
        case .value(let value):
            try value.encode(to: encoder)
        }
    }
}
