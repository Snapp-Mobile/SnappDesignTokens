//
//  TokenValue.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

/// Represents the actual value of a design token.
///
/// Each case corresponds to a DTCG token type with its specific value structure.
/// Token values are decoded based on the token's type property, which can be
/// set directly, inherited from a parent group, or mapped via custom type configuration.
public enum TokenValue: Decodable, DecodableWithConfiguration, Encodable,
    EncodableWithConfiguration, Equatable, Sendable
{
    // MARK: - Primitive Types

    /// Color token value.
    case color(ColorValue)

    /// Dimension token value (width, height, position).
    case dimension(DimensionValue)

    /// File reference token value.
    case file(FileValue)

    /// Font family name token value.
    case fontFamily(FontFamilyValue)

    /// Font weight token value.
    case fontWeight(FontWeightValue)

    /// Numeric token value without units.
    case number(NumberValue)

    /// Time duration token value for animations.
    case duration(DurationValue)

    /// Animation timing curve token value.
    case cubicBezier(CubicBezierValue)

    // MARK: - Composite Types

    /// Typography token value with complete text styling.
    case typography(TypographyValue)

    /// Gradient token value with color transitions.
    case gradient(GradientValue)

    /// Shadow effect token value.
    case shadow(TokenCollection<ShadowValue>)

    /// Stroke style token value for lines and borders.
    case strokeStyle(StrokeStyleValue)

    /// Border token value with color, width, and style.
    case border(BorderValue)

    /// Transition token value for animated state changes.
    case transition(TransitionValue)

    /// Decodes a token value using the specified configuration.
    ///
    /// The value structure is determined by the token type from the configuration.
    /// Custom type mappings are applied before decoding if provided.
    ///
    /// - Parameters:
    ///   - decoder: Decoder to read data from
    ///   - configuration: Configuration specifying token type and decoding options
    /// - Throws: ``DecodingError`` if type is not specified or value structure is invalid
    public init(
        from decoder: any Decoder,
        configuration: TokenValueDecodingConfiguration
    ) throws {
        let mappedType =
            configuration.type.map {
                configuration.customTypeMapping?[$0]
            } ?? nil
        switch mappedType ?? configuration.type {
        case .color:
            self = try .color(ColorValue(from: decoder))
        case .dimension:
            self = try .dimension(DimensionValue(from: decoder))
        case .file:
            self = try .file(
                FileValue(
                    from: decoder,
                    configuration: configuration.fileDecodingConfiguration
                )
            )
        case .fontFamily:
            self = try .fontFamily(FontFamilyValue(from: decoder))
        case .fontWeight:
            self = try .fontWeight(FontWeightValue(from: decoder))
        case .number:
            self = try .number(NumberValue(from: decoder))
        case .typography:
            self = try .typography(TypographyValue(from: decoder))
        case .gradient:
            self = try .gradient(GradientValue(from: decoder))
        case .duration:
            self = try .duration(DurationValue(from: decoder))
        case .shadow:
            self = try .shadow(TokenCollection<ShadowValue>(from: decoder))
        case .strokeStyle:
            self = try .strokeStyle(StrokeStyleValue(from: decoder))
        case .border:
            self = try .border(BorderValue(from: decoder))
        case .cubicBezier:
            self = try .cubicBezier(CubicBezierValue(from: decoder))
        case .transition:
            self = try .transition(TransitionValue(from: decoder))
        case .none:
            fallthrough
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Token value type is not specified."
                )
            )
        }
    }

    public init(from decoder: any Decoder) throws {
        try self.init(
            from: decoder,
            configuration: TokenValueDecodingConfiguration(
                type: decoder.tokenDecodingConfiguration.parentType,
                file: decoder.tokenDecodingConfiguration
                    .fileDecodingConfiguration,
                customTypeMapping: decoder.tokenDecodingConfiguration
                    .customTypeMapping
            )
        )
    }

    public func encode(to encoder: any Encoder) throws {
        try self.encode(
            to: encoder,
            configuration: encoder.tokenEncodingConfiguration
                .tokenValueEncodingConfiguration ?? .default
        )
    }

    /// Encodes the token value using the specified configuration.
    ///
    /// - Parameters:
    ///   - encoder: Encoder to write data to
    ///   - configuration: Configuration specifying encoding options per type
    public func encode(
        to encoder: any Encoder,
        configuration: TokenValueEncodingConfiguration
    ) throws {
        switch self {
        case .color(let colorValue):
            try colorValue.encode(
                to: encoder,
                configuration: configuration.colorEncodingConfiguration
                    ?? .default
            )
        case .dimension(let dimensionValue):
            try dimensionValue.encode(to: encoder)
        case .file(let fileValue):
            try fileValue.encode(to: encoder)
        case .fontFamily(let fontFamilyValue):
            try fontFamilyValue.encode(to: encoder)
        case .fontWeight(let fontWeight):
            try fontWeight.encode(to: encoder)
        case .number(let number):
            try number.encode(to: encoder)
        case .typography(let typography):
            try typography.encode(to: encoder)
        case .gradient(let gradient):
            try gradient.encode(to: encoder)
        case .duration(let duration):
            try duration.encode(to: encoder)
        case .shadow(let shadow):
            try shadow.encode(to: encoder)
        case .strokeStyle(let strokeStyle):
            try strokeStyle.encode(to: encoder)
        case .border(let border):
            try border.encode(to: encoder)
        case .cubicBezier(let cubicBezier):
            try cubicBezier.encode(to: encoder)
        case .transition(let transition):
            try transition.encode(to: encoder)
        }
    }
}

extension TokenValue {
    /// The token type corresponding to this value.
    var tokenType: TokenType {
        switch self {
        case .color: .color
        case .dimension: .dimension
        case .file: .file
        case .fontFamily: .fontFamily
        case .fontWeight: .fontWeight
        case .number: .number
        case .typography: .typography
        case .gradient: .gradient
        case .duration: .duration
        case .shadow: .shadow
        case .strokeStyle: .strokeStyle
        case .border: .border
        case .cubicBezier: .cubicBezier
        case .transition: .transition
        }
    }
}
