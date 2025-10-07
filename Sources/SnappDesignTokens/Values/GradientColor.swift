//
//  GradientColor.swift
//
//  Created by Oleksii Kolomiiets on 31.03.2025.
//

import Foundation

/// Represents a single color stop in a gradient.
///
/// Used within ``GradientValue`` to define color transitions. Each stop specifies
/// a color and position (0-1, where 0 is start and 1 is end). Both properties
/// support direct values and token aliases.
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
