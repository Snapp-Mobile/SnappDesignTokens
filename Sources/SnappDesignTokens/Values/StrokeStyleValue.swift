//
//  StrokeStyleValue.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import Foundation

// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
// Reason: Documentation is in `StrokeStyle.md`
public enum StrokeStyleValue: Codable, Equatable, Sendable, CompositeToken {
    /// Predefined stroke line styles.
    ///
    /// DTCG-compliant line style values following CSS "line style" specification.
    /// Exact visual rendering is implementation-specific.
    public enum LineStyle: String, Codable, Equatable, Sendable {
        /// Solid continuous line.
        case solid

        /// Dashed line pattern.
        case dashed

        /// Dotted line pattern.
        case dotted

        /// Double parallel lines.
        case double

        /// Grooved 3D effect line.
        case groove

        /// Ridged 3D effect line.
        case ridge

        /// Outset 3D effect line.
        case outset

        /// Inset 3D effect line.
        case inset
    }

    /// Line cap style for dash pattern endpoints.
    ///
    /// Determines how the endpoints of dashed line segments are rendered.
    public enum LineCap: String, Codable, Equatable, Sendable {
        /// Rounded cap extending beyond segment endpoint.
        case round

        /// Flat cap flush with segment endpoint.
        case butt

        /// Square cap extending beyond segment endpoint.
        case square
    }

    /// Custom dash pattern with alternating dash and gap lengths.
    ///
    /// Defines stroke dash pattern using dimension array specifying alternating
    /// dash/gap segment lengths with line cap style.
    ///
    /// ### Example
    /// ```swift
    /// let pattern = DashPattern(
    ///     dashArray: [
    ///         .value(.constant(.init(value: 0.5, unit: .rem))),  // dash length
    ///         .value(.constant(.init(value: 0.25, unit: .rem)))  // gap length
    ///     ],
    ///     lineCap: .round
    /// )
    /// ```
    public struct DashPattern: Codable, Equatable, Sendable, CompositeToken {
        /// Alternating dash and gap lengths as ``DimensionValue`` array.
        public let dashArray: [CompositeTokenValue<DimensionValue>]

        /// Line cap style for dash segment endpoints.
        public let lineCap: LineCap

        /// Resolves token aliases in dash array dimension values.
        ///
        /// - Parameter root: Root token for alias resolution
        /// - Throws: Error if alias path is invalid or type mismatch occurs
        public mutating func resolveAliases(root: Token) throws {
            self = try .init(
                dashArray: dashArray.map {
                    try $0.resolvingAliases(root: root)
                },
                lineCap: lineCap
            )
        }
    }

    /// Predefined line style case with ``LineStyle`` value.
    case line(LineStyle)

    /// Custom dash pattern case with ``DashPattern`` structure.
    case dash(DashPattern)

    /// Decodes stroke style from string or dash pattern object.
    ///
    /// Attempts ``LineStyle`` string first, falls back to ``DashPattern`` object.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: `DecodingError` if neither format matches
    public init(from decoder: any Decoder) throws {
        do {
            self = .line(try LineStyle(from: decoder))
        } catch {
            self = .dash(try DashPattern(from: decoder))
        }
    }

    /// Encodes stroke style as either string line style or dash pattern object.
    ///
    /// - Parameter encoder: The encoder to write data to
    /// - Throws: Encoding error if value cannot be encoded
    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .line(let lineStyle):
            try lineStyle.encode(to: encoder)
        case .dash(let dashPattern):
            try dashPattern.encode(to: encoder)
        }
    }

    /// Resolves token aliases within dash pattern if present.
    ///
    /// No-op for line styles; resolves dimension aliases in ``DashPattern`` dash array.
    ///
    /// - Parameter root: Root token for alias resolution
    /// - Throws: Error if alias path is invalid or type mismatch occurs
    public mutating func resolveAliases(root: Token) throws {
        guard case .dash(var pattern) = self else { return }
        try pattern.resolveAliases(root: root)
        self = .dash(pattern)
    }
}
