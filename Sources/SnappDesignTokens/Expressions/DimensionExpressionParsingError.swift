//
//  DimensionExpressionParsingError.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

public enum DimensionExpressionParsingError: Error, LocalizedError, Equatable {
    case invalidFormat
    case invalidElement(String)

    public var errorDescription: String? {
        switch self {
        case .invalidFormat:
            return "Invalid format for dimension expression"
        case .invalidElement(let element):
            return "Invalid element: \(element)"
        }
    }

    public static func == (
        lhs: DimensionExpressionParsingError,
        rhs: DimensionExpressionParsingError
    ) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
