//
//  DurationValue.swift
//
//  Created by Volodymyr Voiko on 31.03.2025.
//

import Foundation

/// Represents a time duration for animations and transitions.
///
/// DTCG primitive token type for measuring animation timing, transition delays, and
/// other time-based values. This is a ``TokenMeasurement`` specialized for
/// ``DurationUnit`` (s, ms).
///
/// Example:
/// ```swift
/// // 100 milliseconds
/// let quick = DurationValue(value: 100, unit: .millisecond)
///
/// // 1.5 seconds
/// let long = DurationValue(value: 1.5, unit: .second)
/// ```
public typealias DurationValue = TokenMeasurement<DurationUnit>
