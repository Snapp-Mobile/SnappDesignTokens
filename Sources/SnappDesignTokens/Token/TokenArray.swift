//
//  TokenArray.swift
//
//  Created by Volodymyr Voiko on 18.03.2025.
//

import Foundation

/// An array of design tokens.
///
/// Represents sequences of tokens used in composite token values like gradient stops,
/// shadow layers, or font family fallbacks. Inherits parent configuration including
/// type and custom mappings.
///
/// Example:
/// ```swift
/// let fontStack: TokenArray = [
///     .value(.fontFamily("Helvetica")),
///     .value(.fontFamily("Arial")),
///     .value(.fontFamily("sans-serif"))
/// ]
/// ```
public typealias TokenArray = [Token]

extension TokenArray {
    /// Decodes a token array using the parent configuration.
    ///
    /// Each token in the array inherits the parent configuration for type resolution.
    ///
    /// - Parameters:
    ///   - decoder: Decoder to read data from
    ///   - configuration: Parent configuration including inherited type and custom mappings
    /// - Throws: `DecodingError` if array structure is invalid
    init(
        from decoder: any Decoder,
        parentConfiguration configuration: TokenDecodingConfiguration
    ) throws {
        var values = [Token]()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let value = try container.decode(
                Token.self,
                configuration: configuration
            )
            values.append(value)
        }
        self.init(values)
    }
}
