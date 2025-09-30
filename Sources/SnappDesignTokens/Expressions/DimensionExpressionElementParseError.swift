//
//  DimensionExpressionElementParseError.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

public enum DimensionExpressionElementParseError: String, Error, LocalizedError {
    case invalidFormat

    public var errorDescription: String? {
        switch self {
        case .invalidFormat:
            "Invalid format for dimension expression element"
        }
    }
}

extension DimensionExpressionElementParseError: Equatable {
    public static func == (
        lhs: DimensionExpressionElementParseError,
        rhs: DimensionExpressionElementParseError
    ) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
