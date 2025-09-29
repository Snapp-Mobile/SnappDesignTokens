//
//  MockRegularExpression.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

@testable import SnappDesignTokens

struct MockRegularExpression: RegularExpressionProtocol {
    enum MockDimensionValueEvaluationError: Error, LocalizedError {
        case mockError
    }
    func expression(pattern: String) throws -> NSRegularExpression {
        throw MockDimensionValueEvaluationError.mockError
    }
}
