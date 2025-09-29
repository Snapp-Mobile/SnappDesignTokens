//
//  DefaultDimensionFormulaSyntax.swift
//
//  Created by Oleksii Kolomiiets on 13.03.2025.
//

import Foundation

open class DefaultDimensionFormulaSyntax: DimensionFormulaSyntax {
    let formula: String

    init(formula: String) {
        self.formula = formula
    }

    /// Validates the formula syntax using a recursive descent parser approach
    /// - Throws: DimensionValueEvaluationError if the formula is invalid
    func isValidFormat() throws(DimensionValueEvaluationError) {
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
