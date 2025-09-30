//
//  TokenArray.swift
//
//  Created by Volodymyr Voiko on 18.03.2025.
//

import Foundation

public typealias TokenArray = [Token]

extension TokenArray {
    init(
        from decoder: any Decoder,
        parentConfiguration configuration: TokenDecodingConfiguration
    ) throws {
        var values = [Token]()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let value = try container.decode(
                Token.self,
                configuration: configuration
            )
            values.append(value)
        }
        self.init(values)
    }
}
