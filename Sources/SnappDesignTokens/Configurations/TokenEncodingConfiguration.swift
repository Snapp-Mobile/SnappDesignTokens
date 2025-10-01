//
//  TokenEncodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

/// Configuration for encoding tokens to JSON.
///
/// Controls token output format including value encoding styles for colors,
/// files, and measurements. Enables customization of output format while
/// maintaining DTCG compliance or generating compact representations.
///
/// Set on ``JSONEncoder`` via `tokenEncodingConfiguration` property:
/// ```swift
/// let encoder = JSONEncoder()
/// encoder.tokenEncodingConfiguration = TokenEncodingConfiguration(
///     tokenValue: TokenValueEncodingConfiguration(
///         color: .hex,
///         measurement: .value(withUnit: true)
///     )
/// )
/// let data = try encoder.encode(token)
/// ```
public struct TokenEncodingConfiguration: Equatable, Sendable {
    /// Default configuration with standard DTCG-compliant output.
    public static let `default` = Self()

    /// Token value encoding configuration as ``TokenValueEncodingConfiguration``.
    ///
    /// Controls encoding format for individual token value types (colors,
    /// files, measurements). When `nil`, uses default formats.
    public let tokenValueEncodingConfiguration:
        TokenValueEncodingConfiguration?

    /// Creates a token encoding configuration.
    ///
    /// - Parameter tokenValueEncodingConfiguration: Value encoding configuration (optional)
    public init(
        tokenValue tokenValueEncodingConfiguration:
            TokenValueEncodingConfiguration? = nil
    ) {
        self.tokenValueEncodingConfiguration = tokenValueEncodingConfiguration
    }
}
