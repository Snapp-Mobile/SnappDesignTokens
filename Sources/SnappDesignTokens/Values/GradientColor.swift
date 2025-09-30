//
//  GradientColor.swift
//
//  Created by Oleksii Kolomiiets on 31.03.2025.
//

import Foundation

/// Represents a single color stop in a gradient.
///
/// Used within ``GradientValue`` to define color transitions. Each stop specifies a color
/// and its position along the gradient axis (0-1 range, where 0 is start and 1 is end).
/// Both properties support direct values and token aliases.
///
/// Per DTCG specification, positions outside [0, 1] are clamped. If no stops exist at
/// 0 or 1, the closest color extends to that end.
///
/// Example:
/// ```swift
/// // Stop at start
/// let blueStart = GradientColor(
///     color: .value(.blue),
///     position: .value(0)
/// )
///
/// // Stop at end using alias
/// let redEnd = GradientColor(
///     color: .alias(TokenPath("brand-primary")),
///     position: .value(1)
/// )
/// ```
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
