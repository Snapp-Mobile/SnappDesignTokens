//
//  TokenProcessor.swift
//
//  Created by Volodymyr Voiko on 03.03.2025.
//

public protocol TokenProcessor: Sendable {
    func process(_ token: Token) async throws -> Token
}
