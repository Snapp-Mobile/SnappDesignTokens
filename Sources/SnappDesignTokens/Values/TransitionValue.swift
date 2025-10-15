//
//  TransitionValue.swift
//
//  Created by Volodymyr Voiko on 03.04.2025.
//

import Foundation

// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
// Reason: Documentation is in `Transition.md`
public struct TransitionValue: Equatable, Sendable, Codable, CompositeToken {
    /// Transition duration as ``CompositeTokenValue`` of ``DurationValue``.
    public let duration: CompositeTokenValue<DurationValue>

    /// Delay before transition starts as ``CompositeTokenValue`` of ``DurationValue``.
    public let delay: CompositeTokenValue<DurationValue>

    /// Timing curve as ``CompositeTokenValue`` of ``CubicBezierValue``.
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
