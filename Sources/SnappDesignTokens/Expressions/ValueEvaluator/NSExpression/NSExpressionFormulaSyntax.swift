//
//  NSExpressionFormulaSyntax.swift
//
//  Created by Oleksii Kolomiiets on 11.03.2025.
//

import Foundation

final class NSExpressionFormulaSyntax<T: RegularExpressionProtocol>: DefaultDimensionFormulaSyntax {
    var regularExpression: T

    /// Regular expression pattern for validating mathematical expressions
    ///
    /// Matches expressions containing numbers and basic operators: **+** , **-**, **\***, **/**
    ///
    /// Examples of valid expressions:
    /// ```swift
    /// "42"
    /// "-3.14"
    /// "10 + 5"
    /// "7 * -2.5"
    /// "1 + 2 - 3 * 4 / 5"
    /// ```
    private let validationPattern: String = {
        let s = #"\s*"#
        let math = #"([+\-/]|[*]{1,2})"#
        let digit = #"(-?\s*\d+(\.\d*)?\s*)"#
        let oneOrMoreExpressions = "(" + s + math + s + digit + ")*"

        let pattern = #"^\s*"# + digit + oneOrMoreExpressions + #"\s*$"#
        return pattern
    }()

    init(formula: String, regularExpression: T = RegularExpression()) {
        self.regularExpression = regularExpression
        super.init(formula: formula)
    }

    override func isValidFormat() throws(DimensionValueEvaluationError) {
        try super.isValidFormat()

        // Additional NSExpression specific validation
        do {
            let validationRegex = try regularExpression.expression(pattern: validationPattern)
            let fullRange = NSRange(formula.startIndex..., in: formula)

            guard validationRegex.firstMatch(in: formula, range: fullRange) != nil else {
                throw DimensionValueEvaluationError.invalidFormula(formula)
            }
        } catch let error as DimensionValueEvaluationError {
            throw error
        } catch {
            throw .regexCompilationFailure(error)
        }
    }
}
