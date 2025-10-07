//
//  DurationValue.swift
//
//  Created by Volodymyr Voiko on 31.03.2025.
//

import Foundation

/// Represents a time duration for animations and transitions.
///
/// Used for animation timing, transition delays, and other time-based values.
/// Specialization of ``TokenMeasurement`` for ``DurationUnit`` (seconds, milliseconds).
public typealias DurationValue = TokenMeasurement<DurationUnit>
