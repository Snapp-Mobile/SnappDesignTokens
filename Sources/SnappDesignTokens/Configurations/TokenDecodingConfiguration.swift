//
//  TokenDecodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

public struct TokenDecodingConfiguration: Equatable, Sendable {
    public static let `default` = Self()

    public let fileDecodingConfiguration: FileValueDecodingConfiguration?
    public var parentType: TokenType?
    public let customTypeMapping: [TokenType: TokenType]?

    public init(
        file fileDecodingConfiguration: FileValueDecodingConfiguration? =
            nil,
        parentType: TokenType? = nil,
        customTypeMapping: [TokenType: TokenType]? = nil
    ) {
        self.fileDecodingConfiguration = fileDecodingConfiguration
        self.parentType = parentType
        self.customTypeMapping = customTypeMapping
    }
}
