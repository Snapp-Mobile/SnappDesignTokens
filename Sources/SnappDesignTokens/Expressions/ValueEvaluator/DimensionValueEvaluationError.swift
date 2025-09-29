//
//  DimensionValueEvaluationError.swift
//
//  Created by Oleksii Kolomiiets on 10.03.2025.
//

import Foundation

/// Errors that can occur during mathematical expression processing
public enum DimensionValueEvaluationError: Error, LocalizedError, Equatable {
    /// The provided string is not a valid mathematical formula
    case invalidFormula(String)

    /// The regular expression for validation failed to compile
    case regexCompilationFailure(Error)

    /// The formula string is empty
    case emptyFormula

    /// An invalid character was encountered during parsing
    case invalidCharacter(Character, position: Int)

    /// The formula has incorrect syntax
    case invalidSyntax(String)

    /// Division by zero was attempted
    case divisionByZero

    /// The parser reached its maximum recursion depth
    case recursionLimitExceeded

    /// A number in the formula is out of the representable range
    case numberOutOfRange

    case unresolvedAlias(path: TokenPath)

    /// Human-readable description of the error
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

    /// Equality comparison for error types
    public static func == (
        lhs: DimensionValueEvaluationError,
        rhs: DimensionValueEvaluationError
    ) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
