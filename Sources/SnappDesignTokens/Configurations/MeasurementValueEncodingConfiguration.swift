//
//  MeasurementValueEncodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

/// Configuration for encoding ``TokenMeasurement`` values.
///
/// Controls output format for measurements combining numeric values with units
/// (dimensions, durations). Supports DTCG-compliant object format or compact
/// value-only representations.
///
/// Used by:
/// - ``DimensionConstant`` (value+unit or bare number)
/// - ``DurationValue`` (value+unit or bare number)
///
/// ### Example
/// ```swift
/// let measurement = TokenMeasurement(value: 16, unit: DimensionUnit.px)
///
/// // .default => {"value": 16, "unit": "px"}
/// // .value(withUnit: true) => "16px"
/// // .value(withUnit: false) => 16
/// ```
public enum MeasurementValueEncodingConfiguration: Equatable, Sendable {
    /// Standard DTCG object format with separate value and unit properties.
    ///
    /// Encodes as object: `{"value": 16, "unit": "px"}`
    case `default`

    /// Compact value format, optionally including unit suffix.
    ///
    /// - Parameter withUnit: When `true`, encodes as string with unit suffix (e.g., `"16px"`).
    ///   When `false`, encodes as bare number (e.g., `16`).
    case value(withUnit: Bool = false)
}
