//
//  DimensionValueConverter.swift
//
//  Created by Volodymyr Voiko on 13.03.2025.
//

public protocol DimensionValueConverter: Sendable {
    func convert(
        _ constant: DimensionConstant,
        to targetUnit: DimensionUnit
    ) -> DimensionConstant
}

extension DimensionValueConverter {
    public func convert(
        _ value: CompositeTokenValue<DimensionValue>,
        to targetUnit: DimensionUnit
    ) -> CompositeTokenValue<DimensionValue> {
        guard case .value(.constant(let constant)) = value else {
            return value
        }

        return .value(.constant(convert(constant, to: targetUnit)))
    }
}
