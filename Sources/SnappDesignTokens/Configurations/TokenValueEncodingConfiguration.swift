//
//  TokenValueEncodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

/// Configuration for encoding token values.
///
/// Aggregates encoding configurations for specific value types (colors, files,
/// measurements). Controls output format at value level while maintaining
/// flexibility across different token types.
///
/// Used via ``TokenEncodingConfiguration``:
/// ```swift
/// let encoder = JSONEncoder()
/// encoder.tokenEncodingConfiguration = TokenEncodingConfiguration(
///     tokenValue: TokenValueEncodingConfiguration(
///         color: .hex,
///         file: .path,
///         measurement: .value(withUnit: true)
///     )
/// )
/// ```
public struct TokenValueEncodingConfiguration: Equatable, Sendable {
    /// Default configuration with standard DTCG-compliant value formats.
    public static let `default` = Self()

    /// Color value encoding configuration as ``ColorValueEncodingConfiguration``.
    ///
    /// Controls color output format (hex string, RGB object, etc.). When `nil`,
    /// uses default format.
    public let colorEncodingConfiguration: ColorValueEncodingConfiguration?

    /// File value encoding configuration as ``FileValueEncodingConfiguration``.
    ///
    /// Controls file output format (path, base64, URL). When `nil`, uses
    /// default format.
    public let fileEncodingConfiguration: FileValueEncodingConfiguration?

    /// Measurement encoding configuration as ``MeasurementValueEncodingConfiguration``.
    ///
    /// Controls dimension and duration output format (object, string with unit,
    /// bare number). When `nil`, uses default format.
    public let measurementEncodingConfiguration: MeasurementValueEncodingConfiguration?

    /// Creates a token value encoding configuration.
    ///
    /// - Parameters:
    ///   - colorEncodingConfiguration: Color encoding configuration (optional)
    ///   - fileEncodingConfiguration: File encoding configuration (optional)
    ///   - measurementEncodingConfiguration: Measurement encoding configuration (optional)
    public init(
        color colorEncodingConfiguration: ColorValueEncodingConfiguration? =
            nil,
        file fileEncodingConfiguration: FileValueEncodingConfiguration? = nil,
        measurement measurementEncodingConfiguration: MeasurementValueEncodingConfiguration? = nil
    ) {
        self.colorEncodingConfiguration = colorEncodingConfiguration
        self.fileEncodingConfiguration = fileEncodingConfiguration
        self.measurementEncodingConfiguration = measurementEncodingConfiguration
    }
}
