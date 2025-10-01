//
//  DimensionExpressionElementParseError.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

/// Errors that occur when parsing dimension expression elements.
///
/// Thrown by ``DimensionExpressionElement`` initializers when string cannot
/// be parsed as operation, alias, or dimension constant.
public enum DimensionExpressionElementParseError: String, Error, LocalizedError {
    /// String format is not a valid expression element.
    ///
    /// String does not match operation symbol, alias syntax, or dimension format.
    case invalidFormat

    /// Human-readable error description.
    public var errorDescription: String? {
        switch self {
        case .invalidFormat:
            "Invalid format for dimension expression element"
        }
    }
}

extension DimensionExpressionElementParseError: Equatable {
    /// Compares errors for equality based on localized descriptions.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand side error
    ///   - rhs: Right-hand side error
    /// - Returns: `true` if errors have identical descriptions
    public static func == (
        lhs: DimensionExpressionElementParseError,
        rhs: DimensionExpressionElementParseError
    ) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
