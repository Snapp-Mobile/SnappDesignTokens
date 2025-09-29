//
//  NSExpressionDimensionEvaluator.swift
//
//  Created by Volodymyr Voiko on 10.03.2025.
//

import Foundation

typealias NSExpressionDimensionEvaluator = DefaultNSExpressionDimensionEvaluator<RegularExpression>

/// A dimension value evaluator that uses NSExpression to calculate numeric values from dimension formulas
struct DefaultNSExpressionDimensionEvaluator<T: RegularExpressionProtocol>: DimensionValueEvaluator {
    let baseUnit: DimensionUnit
    let converter: DimensionValueConverter
    var regularExpression: T

    init(
        baseUnit: DimensionUnit = .px,
        converter: DimensionValueConverter = .default,
        regularExpression: T = RegularExpression()
    ) {
        self.baseUnit = baseUnit
        self.converter = converter
        self.regularExpression = regularExpression
    }

    func evaluate(
        _ expression: DimensionExpression
    ) throws -> DimensionConstant {
        let formula = try expression.formula(
            converter: converter,
            baseUnit: baseUnit
        )

        // Evaluate the value of the expression
        let value: Double = try evaluatedValue(formula)

        // result is in .px always
        return DimensionConstant(value: value, unit: .px)
    }

    private func evaluatedValue(
        _ formula: String
    ) throws(DimensionValueEvaluationError) -> Double {
        // Validate the formula
        try validate(formula)

        let expression = NSExpression(format: formula)
        let value = expression.expressionValue(with: nil, context: nil)

        guard let value, let double = value as? Double else {
            throw .invalidFormula(formula)
        }

        let evaluatedValue: Double = double.roundedToFourDecimalPlaces()

        return evaluatedValue
    }

    private func validate(
        _ formula: String
    ) throws(DimensionValueEvaluationError) {
        let expressionValue = NSExpressionFormulaSyntax(formula: formula, regularExpression: regularExpression)
        try expressionValue.isValidFormat()
    }
}
