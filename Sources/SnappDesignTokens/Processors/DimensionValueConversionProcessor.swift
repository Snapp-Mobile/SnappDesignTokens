//
//  DimensionValueConversionProcessor.swift
//
//  Created by Volodymyr Voiko on 13.03.2025.
//

public struct DimensionValueConversionProcessor: TokenProcessor {
    public let converter: DimensionValueConverter
    public let targetUnit: DimensionUnit

    public init(
        converter: DimensionValueConverter = .default,
        targetUnit: DimensionUnit = .default
    ) {
        self.converter = converter
        self.targetUnit = targetUnit
    }

    public func process(_ token: Token) async throws -> Token {
        token.map { element in
            switch element {
            case .value(.dimension(.constant(let value))):
                let converted = converter.convert(value, to: targetUnit)
                return .value(.dimension(.constant(converted)))
            case .value(.dimension(.expression(let expression))):
                let elements = expression.elements.map { element in
                    guard case .value(let elementValue) = element else {
                        return element
                    }
                    let converted = converter.convert(
                        elementValue, to: targetUnit)
                    return .value(converted)
                }
                let expression = DimensionExpression(elements: elements)
                return .value(.dimension(.expression(expression)))
            case .value(.typography(let typography)):
                let typography = TypographyValue(
                    fontFamily: typography.fontFamily,
                    fontSize: converter.convert(typography.fontSize, to: targetUnit),
                    fontWeight: typography.fontWeight,
                    letterSpacing: converter.convert(typography.letterSpacing, to: targetUnit),
                    lineHeight: typography.lineHeight)
                return .value(.typography(typography))
            case .group, .alias, .value, .unknown, .array:
                return element
            }
        }
    }
}

extension TokenProcessor
where Self == DimensionValueConversionProcessor {
    public static func dimensionValueConversion(
        using converter: DimensionValueConverter = .default,
        targetUnit: DimensionUnit
    ) -> Self {
        DimensionValueConversionProcessor(
            converter: converter,
            targetUnit: targetUnit
        )
    }
}
