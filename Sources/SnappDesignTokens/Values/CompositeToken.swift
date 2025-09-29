//
//  CompositeToken.swift
//
//  Created by Volodymyr Voiko on 26.03.2025.
//

import Foundation

public protocol CompositeToken {
    mutating func resolveAliases(root: Token) throws
}

extension Array: CompositeToken where Element: CompositeToken {
    public mutating func resolveAliases(root: Token) throws {
        for index in indices {
            try self[index].resolveAliases(root: root)
        }
    }
}
