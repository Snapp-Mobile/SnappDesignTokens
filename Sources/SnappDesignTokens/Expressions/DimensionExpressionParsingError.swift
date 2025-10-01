//
//  DimensionExpressionParsingError.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

/// Errors that occur when parsing dimension expression strings.
///
/// Thrown by ``DimensionExpression`` decoder when mathematical formula string
/// cannot be split into valid expression elements.
public enum DimensionExpressionParsingError: Error, LocalizedError, Equatable {
    /// Expression string has invalid overall format.
    ///
    /// String is empty or cannot be tokenized into elements.
    case invalidFormat

    /// Specific element in expression is invalid.
    ///
    /// Element substring does not match any valid pattern (operation, alias,
    /// or dimension constant).
    case invalidElement(String)

    /// Human-readable error description.
    public var errorDescription: String? {
        switch self {
        case .invalidFormat:
            return "Invalid format for dimension expression"
        case .invalidElement(let element):
            return "Invalid element: \(element)"
        }
    }

    /// Compares errors for equality based on localized descriptions.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand side error
    ///   - rhs: Right-hand side error
    /// - Returns: `true` if errors have identical descriptions
    public static func == (
        lhs: DimensionExpressionParsingError,
        rhs: DimensionExpressionParsingError
    ) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
