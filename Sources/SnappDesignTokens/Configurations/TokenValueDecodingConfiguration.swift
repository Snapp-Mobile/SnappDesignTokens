//
//  TokenValueDecodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

public struct TokenValueDecodingConfiguration: Equatable, Sendable {
    public let type: TokenType?
    public let fileDecodingConfiguration: FileValueDecodingConfiguration?
    public let customTypeMapping: [TokenType: TokenType]?

    public init(
        type: TokenType?,
        file fileDecodingConfiguration: FileValueDecodingConfiguration?,
        customTypeMapping: [TokenType: TokenType]?
    ) {
        self.type = type
        self.fileDecodingConfiguration = fileDecodingConfiguration
        self.customTypeMapping = customTypeMapping
    }
}
