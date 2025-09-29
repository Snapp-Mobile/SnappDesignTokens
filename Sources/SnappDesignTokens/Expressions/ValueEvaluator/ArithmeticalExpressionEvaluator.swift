//
//  ArithmeticalExpressionEvaluator.swift
//
//  Created by Oleksii Kolomiiets on 11.03.2025.
//

import Foundation

/// A struct that evaluates mathematical expressions provided as strings.
/// Conforms to `DimensionValueEvaluator` protocol to provide numeric evaluation capabilities.
struct ArithmeticalExpressionEvaluator: DimensionValueEvaluator {
    let baseUnit: DimensionUnit
    let converter: DimensionValueConverter

    init(
        baseUnit: DimensionUnit = .px,
        converter: DimensionValueConverter = .default
    ) {
        self.baseUnit = baseUnit
        self.converter = converter
    }

    func evaluate(_ expression: DimensionExpression) throws -> DimensionConstant {
        let formula = try expression.formula(converter: converter, baseUnit: baseUnit)
        let manager = ArithmeticalExpressionManager<Double>(formula: formula)
        let evaluatedValue = try manager.evaluate()
        return .init(value: evaluatedValue, unit: baseUnit)
    }
}
