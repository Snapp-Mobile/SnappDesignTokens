//
//  DefaultDimensionValueConverter.swift
//
//  Created by Volodymyr Voiko on 13.03.2025.
//

/// Default dimension unit converter supporting px and rem.
///
/// Converts dimension values between px and rem units using configurable base
/// values. Implements proportional conversion through intermediate base unit
/// calculation.
///
/// Conversion algorithm:
/// 1. Convert source value to base units: `value * sourceBaseValue`
/// 2. Convert base units to target: `baseValue / targetBaseValue`
///
/// ### Example
/// ```swift
/// let converter = DefaultDimensionValueConverter(remBaseValue: 16, pxBaseValue: 1)
/// let px = DimensionConstant(value: 16, unit: .px)
/// let rem = converter.convert(px, to: .rem)  // 1rem (16px / 16 = 1rem)
/// ```
public struct DefaultDimensionValueConverter: DimensionValueConverter {
    /// Base value for rem unit in px (typically 16px = 1rem).
    public let remBaseValue: Double

    /// Base value for px unit (typically 1).
    public let pxBaseValue: Double

    /// Creates a dimension value converter.
    ///
    /// - Parameters:
    ///   - remBaseValue: Rem base value in pixels (default: 16)
    ///   - pxBaseValue: Pixel base value multiplier (default: 1)
    public init(remBaseValue: Double = 16, pxBaseValue: Double = 1) {
        self.remBaseValue = remBaseValue
        self.pxBaseValue = pxBaseValue
    }

    /// Converts dimension constant to target unit.
    ///
    /// Performs proportional conversion through base unit intermediate values.
    ///
    /// - Parameters:
    ///   - constant: Source dimension constant to convert
    ///   - targetUnit: Target dimension unit
    /// - Returns: Converted dimension constant in target unit
    public func convert(
        _ constant: DimensionConstant,
        to targetUnit: DimensionUnit
    ) -> DimensionConstant {
        let baseValueForGivenUnit = baseValueForUnit(constant.unit)
        let convertedValueInBase = constant.value * baseValueForGivenUnit
        let baseValueForTargetUnit = baseValueForUnit(targetUnit)
        let valueInTargetUnit = convertedValueInBase / baseValueForTargetUnit
        return .init(value: valueInTargetUnit, unit: targetUnit)
    }

    private func baseValueForUnit(_ unit: DimensionUnit) -> Double {
        switch unit {
        case .rem: remBaseValue
        case .px: pxBaseValue
        }
    }
}

extension DimensionValueConverter where Self == DefaultDimensionValueConverter {
    /// Default converter with standard rem base (16px = 1rem).
    public static var `default`: Self { DefaultDimensionValueConverter() }

    /// Creates converter with custom base values.
    ///
    /// - Parameters:
    ///   - remBaseValue: Rem base value in pixels (default: 16)
    ///   - pxBaseValue: Pixel base value multiplier (default: 1)
    /// - Returns: Configured ``DefaultDimensionValueConverter``
    public static func converter(with remBaseValue: Double = 16, pxBaseValue: Double = 1) -> Self {
        DefaultDimensionValueConverter(remBaseValue: remBaseValue, pxBaseValue: pxBaseValue)
    }
}
