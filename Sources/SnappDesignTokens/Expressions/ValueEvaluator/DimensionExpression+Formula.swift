//
//  DimensionExpression+Formula.swift
//
//  Created by Volodymyr Voiko on 08.04.2025.
//

extension DimensionExpression {
    func formula(converter: DimensionValueConverter, baseUnit: DimensionUnit) throws -> String {
        try elements.map { element in
            switch element {
            case .operation(let operation):
                return operation.rawValue
            case let .alias(path):
                // Throw an error if aliases are still not resolved at this point
                throw DimensionValueEvaluationError.unresolvedAlias(path: path)
            case .value(let dimension):
                let dimensionValue = converter.convert(dimension, to: baseUnit)
                return String(describing: dimensionValue.value)
            }
        }.joined()
    }
}
