//
//  UnitType.swift
//
//  Created by Volodymyr Voiko on 31.03.2025.
//

import Foundation

/// Protocol for unit types used in token measurements.
///
/// Enables custom decoding behavior for token types that combine numeric values with
/// units (e.g., dimension, duration). Conforming types can define specialized parsing
/// for formats like `"16px"`, `"2rem"`, or `"300ms"`.
///
/// Conforming types must be string-representable enums where `rawValue` is the unit
/// identifier (e.g., `"px"`, `"rem"`, `"ms"`).
///
/// ### Example
/// ```swift
/// enum DimensionUnit: String, UnitType {
///     case px
///     case rem
/// }
///
/// enum DurationUnit: String, UnitType {
///     case second = "s"
///     case millisecond = "ms"
/// }
/// ```
public protocol UnitType:
    Codable,
    Equatable,
    Sendable,
    RawRepresentable
where RawValue == String {
    /// Attempts custom decoding of a measurement value with this unit type.
    ///
    /// Override this method to support specialized decoding formats. For example,
    /// ``DimensionUnit`` decodes both `"16px"` strings and bare numbers with default unit.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Returns: Decoded ``TokenMeasurement``, or `nil` to fall back to standard decoding
    /// - Throws: `DecodingError` if custom decoding fails
    static func decode(_ decoder: any Decoder) throws -> TokenMeasurement<Self>?
}

extension UnitType {
    /// Default implementation returns `nil` to use standard decoding.
    ///
    /// - Parameter decoder: Decoder (unused in default implementation)
    /// - Returns: `nil` to fall back to standard ``TokenMeasurement`` decoding
    public static func decode(_: any Decoder) throws -> TokenMeasurement<Self>? { nil }
}
