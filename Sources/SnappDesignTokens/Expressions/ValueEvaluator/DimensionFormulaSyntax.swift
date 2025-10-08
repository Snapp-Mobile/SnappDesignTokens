//
//  DimensionFormulaSyntax.swift
//
//  Created by Oleksii Kolomiiets on 13.03.2025.
//

import Foundation

/// Protocol that defines requirements for formula syntax validation
public protocol DimensionFormulaSyntax {
    /// Validates whether the formula conforms to expected format
    /// - Throws: DimensionValueEvaluationError if validation fails
    func isValidFormat() throws(DimensionValueEvaluationError)
}
