//
//  DimensionValueConversionProcessor.swift
//
//  Created by Volodymyr Voiko on 13.03.2025.
//

/// Processor that converts dimension values to a target unit.
///
/// Traverses token tree converting all dimension values (constants, expressions,
/// typography dimensions) to specified target unit using ``DimensionValueConverter``.
/// Handles dimension constants, expression elements, and typography font size/letter spacing.
///
/// ### Example
/// ```swift
/// // Tokens with mixed units: { "spacing": "16px", "margin": "1rem" }
///
/// let processor: TokenProcessor = .dimensionValueConversion(targetUnit: .rem)
/// let converted = try await processor.process(token)
/// // Result: { "spacing": "1rem", "margin": "1rem" }
/// ```
public struct DimensionValueConversionProcessor: TokenProcessor {
    /// Converter for unit conversion calculations as ``DimensionValueConverter``.
    public let converter: DimensionValueConverter

    /// Target unit for all dimension values as ``DimensionUnit``.
    public let targetUnit: DimensionUnit

    /// Creates a dimension value conversion processor.
    ///
    /// - Parameters:
    ///   - converter: Converter implementation (default: `.default`)
    ///   - targetUnit: Target dimension unit (default: `.default`)
    public init(
        converter: DimensionValueConverter = .default,
        targetUnit: DimensionUnit = .default
    ) {
        self.converter = converter
        self.targetUnit = targetUnit
    }

    /// Converts all dimension values to target unit.
    ///
    /// Processes dimension constants, expression elements, and typography
    /// dimensions (fontSize, letterSpacing). Non-dimension tokens pass through
    /// unchanged.
    ///
    /// - Parameter token: Token tree to process
    /// - Returns: Token tree with dimensions converted to target unit
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
                        elementValue,
                        to: targetUnit
                    )
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
                    lineHeight: typography.lineHeight
                )
                return .value(.typography(typography))
            case .group, .alias, .value, .unknown, .array:
                return element
            }
        }
    }
}

extension TokenProcessor
where Self == DimensionValueConversionProcessor {
    /// Creates a dimension value conversion processor.
    ///
    /// - Parameters:
    ///   - converter: Converter implementation (default: `.default`)
    ///   - targetUnit: Target dimension unit
    /// - Returns: Configured ``DimensionValueConversionProcessor``
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
