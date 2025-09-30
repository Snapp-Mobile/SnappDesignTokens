//
//  TransitionValue.swift
//
//  Created by Volodymyr Voiko on 03.04.2025.
//

import Foundation

/// Represents an animated transition between two states.
///
/// DTCG composite token defining transition timing with three required properties. Each
/// property supports both direct values and token aliases.
///
/// Example:
/// ```swift
/// let emphasis = TransitionValue(
///     duration: .value(.init(value: 200, unit: .millisecond)),
///     delay: .value(.init(value: 0, unit: .millisecond)),
///     timingFunction: .value(.init(x1: 0.5, y1: 0, x2: 1, y2: 1))
/// )
/// ```
public struct TransitionValue: Equatable, Sendable, Codable, CompositeToken {
    /// Transition length as ``CompositeTokenValue`` of ``DurationValue``.
    public let duration: CompositeTokenValue<DurationValue>

    /// Wait time before transition starts as ``CompositeTokenValue`` of ``DurationValue``.
    public let delay: CompositeTokenValue<DurationValue>

    /// Animation curve as ``CompositeTokenValue`` of ``CubicBezierValue``.
    public let timingFunction: CompositeTokenValue<CubicBezierValue>

    /// Creates a transition with the specified timing properties.
    ///
    /// - Parameters:
    ///   - duration: Transition length
    ///   - delay: Wait time before transition starts
    ///   - timingFunction: Animation curve
    public init(
        duration: CompositeTokenValue<DurationValue>,
        delay: CompositeTokenValue<DurationValue>,
        timingFunction: CompositeTokenValue<CubicBezierValue>
    ) {
        self.duration = duration
        self.delay = delay
        self.timingFunction = timingFunction
    }

    /// Resolves all token aliases to their actual values.
    ///
    /// Traverses each property to resolve any `{group.token}` references.
    ///
    /// - Parameter root: Root token containing the complete token tree for lookups
    /// - Throws: Error if any alias cannot be resolved or type mismatch occurs
    public mutating func resolveAliases(root: Token) throws {
        self = try .init(
            duration: duration.resolvingAliases(root: root),
            delay: delay.resolvingAliases(root: root),
            timingFunction: timingFunction.resolvingAliases(root: root)
        )
    }
}
