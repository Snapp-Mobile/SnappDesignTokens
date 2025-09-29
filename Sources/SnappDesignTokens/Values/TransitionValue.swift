//
//  TransitionValue.swift
//
//  Created by Volodymyr Voiko on 03.04.2025.
//

import Foundation

public struct TransitionValue: Equatable, Sendable, Codable, CompositeToken {
    public let duration: CompositeTokenValue<DurationValue>
    public let delay: CompositeTokenValue<DurationValue>
    public let timingFunction: CompositeTokenValue<CubicBezierValue>

    public init(
        duration: CompositeTokenValue<DurationValue>,
        delay: CompositeTokenValue<DurationValue>,
        timingFunction: CompositeTokenValue<CubicBezierValue>
    ) {
        self.duration = duration
        self.delay = delay
        self.timingFunction = timingFunction
    }

    public mutating func resolveAliases(root: Token) throws {
        self = try .init(
            duration: duration.resolvingAliases(root: root),
            delay: delay.resolvingAliases(root: root),
            timingFunction: timingFunction.resolvingAliases(root: root)
        )
    }
}
