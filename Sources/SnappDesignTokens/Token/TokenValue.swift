//
//  TokenValue.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

public enum TokenValue: Decodable, DecodableWithConfiguration, Encodable,
    EncodableWithConfiguration, Equatable, Sendable
{
    case color(ColorValue)
    case dimension(DimensionValue)
    case file(FileValue)
    case fontFamily(FontFamilyValue)
    case fontWeight(FontWeightValue)
    case number(NumberValue)
    case typography(TypographyValue)
    case gradient(GradientValue)
    case duration(DurationValue)
    case shadow(TokenCollection<ShadowValue>)
    case strokeStyle(StrokeStyleValue)
    case border(BorderValue)
    case cubicBezier(CubicBezierValue)
    case transition(TransitionValue)

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
