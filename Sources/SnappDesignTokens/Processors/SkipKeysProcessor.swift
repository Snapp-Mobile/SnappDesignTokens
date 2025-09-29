//
//  SkipKeysProcessor.swift
//
//  Created by Volodymyr Voiko on 09.04.2025.
//


import Foundation

public struct SkipKeysProcessor: TokenProcessor {
    public let skippedKeys: Set<String>
    
    public init(skippedKeys: Set<String> = []) {
        self.skippedKeys = skippedKeys
    }
    
    public func process(_ token: Token) async throws -> Token {
        guard case .group(var group) = token else {
            return token
        }
        for key in skippedKeys {
            group.removeValue(forKey: key)
        }
        return .group(group)
    }
}

extension TokenProcessor where Self == SkipKeysProcessor {
    public static func skipKeys(_ keys: String...) -> Self {
        .init(skippedKeys: .init(keys))
    }

    public static func skipKeys(_ keys: [String]) -> Self {
        .init(skippedKeys: .init(keys))
    }
}
