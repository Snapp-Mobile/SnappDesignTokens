//
//  DefaultDimensionFormulaSyntax.swift
//
//  Created by Oleksii Kolomiiets on 13.03.2025.
//

import Foundation

/// Default implementation of dimension formula syntax validation.
///
/// Validates mathematical formulas used in dimension token calculations,
/// ensuring they contain only allowed characters and operations.
public class DefaultDimensionFormulaSyntax: DimensionFormulaSyntax {
    /// The formula string to validate and evaluate.
    let formula: String

    /// Creates a new formula syntax validator.
    ///
    /// - Parameter formula: Mathematical formula string
    public init(formula: String) {
        self.formula = formula
    }

    /// Validates the formula syntax using a recursive descent parser approach.
    ///
    /// Checks for empty formulas, length limits (max 1000 characters), and ensures
    /// only allowed characters (alphanumerics, arithmetic operators, parentheses, and periods)
    /// are present.
    ///
    /// - Throws: ``DimensionValueEvaluationError`` if the formula is empty, too long, or contains invalid characters
    public func isValidFormat() throws(DimensionValueEvaluationError) {
        // Check for empty formula
        if formula.isEmpty {
            throw .emptyFormula
        }

        // Check for formula length to prevent DoS attacks
        if formula.count > 1000 {
            throw .invalidSyntax("Formula too long (max 1000 characters)")
        }

        // Validate formula contains only allowed characters
        let arithmeticSymbols = ArithmeticOperation.allCases.map(\.rawValue)
        let allowedCharacters = CharacterSet.alphanumerics
            .union(CharacterSet(charactersIn: arithmeticSymbols.joined() + "."))

        if formula.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            throw .invalidSyntax("Invalid characters in formula")
        }

        // Validate characters in formula
        let allowedChars = CharacterSet(charactersIn: "0123456789.+-*/() ")
        for (index, char) in formula.enumerated() {
            if String(char).rangeOfCharacter(from: allowedChars) == nil {
                throw .invalidCharacter(char, position: index)
            }
        }
    }
}
