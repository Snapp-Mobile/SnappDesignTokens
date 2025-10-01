//
//  TokenValue+Mocks.swift
//
//  Created by Volodymyr Voiko on 04.03.2025.
//

import SnappDesignTokens

extension DimensionValue {
    static let tenPixels = DimensionValue(value: 10, unit: .px)
    static let twoREM = DimensionValue(value: 2, unit: .rem)
}

extension TokenValue {
    static let reddishColor: TokenValue = .color(.reddish)
    static let smallSpacing: TokenValue = .dimension(.twoREM)
}
