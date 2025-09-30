//
//  NumberValue.swift
//
//  Created by Volodymyr Voiko on 27.03.2025.
//

/// Represents a unitless numeric token value.
///
/// DTCG primitive token for generic numeric values without specific units. Used for
/// line heights, gradient stop positions, opacity values, and other unitless measurements.
/// Distinct from dimension tokens which include units like px or rem.
///
/// Example:
/// ```swift
/// let lineHeight: NumberValue = 1.5
/// let opacity: NumberValue = 0.8
/// let gradientStop: NumberValue = 0.25
/// ```
public typealias NumberValue = Double
