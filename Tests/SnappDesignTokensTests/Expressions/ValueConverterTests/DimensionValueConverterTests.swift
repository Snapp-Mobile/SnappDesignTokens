//
//  DimensionValueConverterTests.swift
//
//  Created by Volodymyr Voiko on 13.03.2025.
//

import Testing

@testable import SnappDesignTokens

struct DimensionValueConverterTests {
    let converter: DimensionValueConverter = DefaultDimensionValueConverter()
    @Test(
        arguments: [
            (
                DimensionConstant(value: 16, unit: .px),
                .rem,
                DimensionConstant(value: 1, unit: .rem)
            ),
            (
                DimensionConstant(value: 3, unit: .rem),
                .px,
                DimensionConstant(value: 48, unit: .px)
            ),
            (
                DimensionConstant(value: 2, unit: .px),
                .px,
                DimensionConstant(value: 2, unit: .px)
            ),
            (
                DimensionConstant(value: 3, unit: .rem),
                .rem,
                DimensionConstant(value: 3, unit: .rem)
            ),
        ]
            as [(
                DimensionConstant,
                DimensionUnit,
                DimensionConstant
            )]
    )
    func textConversion(
        givenValue: DimensionConstant,
        targetUnit: DimensionUnit,
        expectedValue: DimensionConstant
    ) {
        let targetValue = converter.convert(givenValue, to: targetUnit)
        #expect(targetValue == expectedValue)
    }
}
