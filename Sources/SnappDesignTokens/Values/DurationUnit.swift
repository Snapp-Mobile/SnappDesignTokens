//
//  DurationUnit.swift
//
//  Created by Volodymyr Voiko on 31.03.2025.
//

import Foundation

/// Units of time measurement for duration tokens.
///
/// DTCG duration tokens support two standard units for representing animation timing
/// and delays. Conforms to ``UnitType`` for use with ``TokenMeasurement``.
///
/// Per DTCG specification, a millisecond is one thousandth of a second.
///
/// Example:
/// ```swift
/// let seconds = DurationUnit.second
/// let milliseconds = DurationUnit.millisecond
/// ```
public enum DurationUnit: String, UnitType {
    /// Seconds - base unit of time.
    case second = "s"

    /// Milliseconds - one thousandth of a second (1/1000s).
    case millisecond = "ms"
}
