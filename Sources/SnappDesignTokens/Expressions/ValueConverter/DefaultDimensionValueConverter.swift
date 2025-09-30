//
//  DefaultDimensionValueConverter.swift
//
//  Created by Volodymyr Voiko on 13.03.2025.
//

public struct DefaultDimensionValueConverter: DimensionValueConverter {
    public let remBaseValue: Double
    public let pxBaseValue: Double

    public init(remBaseValue: Double = 16, pxBaseValue: Double = 1) {
        self.remBaseValue = remBaseValue
        self.pxBaseValue = pxBaseValue
    }

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
    public static var `default`: Self { DefaultDimensionValueConverter() }
    public static func converter(with remBaseValue: Double = 16, pxBaseValue: Double = 1) -> Self {
        DefaultDimensionValueConverter(remBaseValue: remBaseValue, pxBaseValue: pxBaseValue)
    }
}
