//
//  TokenEncodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

public struct TokenEncodingConfiguration: Equatable, Sendable {
    public static let `default` = Self()

    public let tokenValueEncodingConfiguration:
        TokenValueEncodingConfiguration?

    public init(
        tokenValue tokenValueEncodingConfiguration:
            TokenValueEncodingConfiguration? = nil
    ) {
        self.tokenValueEncodingConfiguration = tokenValueEncodingConfiguration
    }
}
