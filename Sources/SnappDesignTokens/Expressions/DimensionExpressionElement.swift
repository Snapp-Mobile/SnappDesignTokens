//
//  DimensionExpressionElement.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

public enum DimensionExpressionElement: Equatable, Sendable, RawRepresentable {
    case operation(ArithmeticOperation)
    case alias(TokenPath)
    case value(DimensionConstant)

    public var rawValue: String {
        switch self {
        case .operation(let operation):
            return operation.rawValue
        case .alias(let path):
            return path.rawValue
        case .value(let dimension):
            return String(describing: dimension.value) + dimension.unit.rawValue
        }
    }

    public init(from stringValue: String) throws {
        if let operation = ArithmeticOperation(rawValue: stringValue) {
            self = .operation(operation)
        } else if let path = try? TokenPath(from: stringValue) {
            self = .alias(path)
        } else if let value = try? DimensionConstant(stringValue: stringValue) {
            self = .value(value)
        } else {
            throw DimensionExpressionElementParseError.invalidFormat
        }
    }

    public init?(rawValue: String) {
        try? self.init(from: rawValue)
    }
}

extension DimensionExpressionElement {
    public static func value(_ value: Double, _ unit: DimensionUnit = .px) -> Self {
        .value(DimensionConstant(value: value, unit: unit))
    }

    public static let add: Self = .operation(.add)
    public static let multiply: Self = .operation(.multiply)
    public static let divide: Self = .operation(.divide)
    public static let subtract: Self = .operation(.subtract)
}
