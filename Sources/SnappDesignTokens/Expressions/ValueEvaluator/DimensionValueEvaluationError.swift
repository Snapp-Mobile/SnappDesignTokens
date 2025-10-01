//
//  DimensionValueEvaluationError.swift
//
//  Created by Oleksii Kolomiiets on 10.03.2025.
//

import Foundation

/// Errors that can occur during dimension expression evaluation.
///
/// Thrown by ``DimensionValueEvaluator`` implementations when parsing or
/// computing dimension expressions fails.
public enum DimensionValueEvaluationError: Error, LocalizedError, Equatable {
    /// Provided string is not a valid mathematical formula.
    case invalidFormula(String)

    /// Regular expression for validation failed to compile.
    case regexCompilationFailure(Error)

    /// Formula string is empty.
    case emptyFormula

    /// Invalid character encountered during parsing.
    ///
    /// - Parameters:
    ///   - character: Invalid character found
    ///   - position: Character position in formula string
    case invalidCharacter(Character, position: Int)

    /// Formula has incorrect syntax.
    case invalidSyntax(String)

    /// Division by zero was attempted.
    case divisionByZero

    /// Parser reached its maximum recursion depth.
    ///
    /// Indicates excessively nested expressions that could cause stack overflow.
    case recursionLimitExceeded

    /// Number in formula is out of representable range.
    ///
    /// Value is too large, too small, infinite, or NaN.
    case numberOutOfRange

    /// Unresolved alias reference in expression.
    ///
    /// Alias could not be resolved to a concrete dimension value.
    case unresolvedAlias(path: TokenPath)

    /// Human-readable error description.
    public var errorDescription: String? {
        switch self {
        case .invalidFormula(let input):
            return "Not a valid mathematical formula: '\(input)'"
        case .regexCompilationFailure(let error):
            return "Failed to compile validation pattern: '\(error.localizedDescription)'"
        case .emptyFormula:
            return "The formula is empty"
        case .invalidCharacter(let char, let position):
            return "Invalid character '\(char)' at position \(position)"
        case .invalidSyntax(let details):
            return "Invalid syntax in formula: \(details)"
        case .divisionByZero:
            return "Division by zero is not allowed"
        case .recursionLimitExceeded:
            return "The formula has too many nested operations"
        case .numberOutOfRange:
            return "A number in the formula is too large or too small to be represented"
        case .unresolvedAlias(let path):
            return "Unresolved alias: \(path.rawValue)"
        }
    }

    /// Compares errors for equality based on localized descriptions.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand side error
    ///   - rhs: Right-hand side error
    /// - Returns: `true` if errors have identical descriptions
    public static func == (
        lhs: DimensionValueEvaluationError,
        rhs: DimensionValueEvaluationError
    ) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
