//
//  GradientColor.swift
//
//  Created by Oleksii Kolomiiets on 31.03.2025.
//

import Foundation

// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
// Reason: Documentation is in `Gradient.md`
public struct GradientColor: Equatable, Sendable, Codable {
    /// Color at this gradient stop as ``CompositeTokenValue`` of ``ColorValue``.
    public let color: CompositeTokenValue<ColorValue>

    /// Position along gradient axis (0-1) as ``CompositeTokenValue`` of ``NumberValue``.
    ///
    /// Value of 0 represents the gradient start, 1 represents the end.
    public let position: CompositeTokenValue<NumberValue>

    /// Creates a gradient color stop with color and position.
    ///
    /// - Parameters:
    ///   - color: Color value or reference
    ///   - position: Position on gradient axis (0-1)
    public init(
        color: CompositeTokenValue<ColorValue>,
        position: CompositeTokenValue<NumberValue>
    ) {
        self.color = color
        self.position = position
    }
}
