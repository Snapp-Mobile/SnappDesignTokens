//
//  ResolveAliasesTokenProcessor.swift
//
//  Created by Volodymyr Voiko on 04.03.2025.
//

import Foundation
import OSLog

public struct ResolveAliasesTokenProcessor: TokenProcessor {
    public init() {}

    public func process(_ token: Token) async throws -> Token {
        var resolved = token
        try resolved.resolveAliases()
        return resolved
    }
}

extension TokenProcessor where Self == ResolveAliasesTokenProcessor {
    public static var resolveAliases: Self {
        ResolveAliasesTokenProcessor()
    }
}
