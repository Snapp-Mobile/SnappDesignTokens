//
//  DimensionValue.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation
import OSLog

public enum DimensionValue: Codable, Equatable, Sendable {
    public static func expression(_ elements: DimensionExpressionElement...) -> Self {
        .expression(DimensionExpression(elements: elements))
    }

    case expression(DimensionExpression)
    case constant(DimensionConstant)

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let constantValue = try? container.decode(DimensionConstant.self)

        switch constantValue {
        case .some(let constantValue):
            self = .constant(constantValue)
        case .none:
            let expression = try container.decode(DimensionExpression.self)
            self = .expression(expression)
        }
    }

    public init(value: Double, unit: DimensionUnit) {
        self = .constant(DimensionConstant(value: value, unit: unit))
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .expression(let expression):
            try expression.encode(to: encoder)
        case .constant(let value):
            try value.encode(to: encoder)
        }
    }
}
