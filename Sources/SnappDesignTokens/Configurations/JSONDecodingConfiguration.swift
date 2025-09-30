//
//  JSONDecodingConfiguration.swift
//
//  Created by Volodymyr Voiko on 08.04.2025.
//

import Foundation

private let decodingConfigurationKey = CodingUserInfoKey(
    rawValue: "TokenDecodingConfiguration"
)!

extension JSONDecoder {
    public var tokenDecodingConfiguration: TokenDecodingConfiguration {
        get {
            userInfo[decodingConfigurationKey]
                as? TokenDecodingConfiguration ?? .default
        }
        set {
            userInfo[decodingConfigurationKey] = newValue
        }
    }
}

extension Decoder {
    public var tokenDecodingConfiguration: TokenDecodingConfiguration {
        userInfo[decodingConfigurationKey] as? TokenDecodingConfiguration
            ?? .default
    }
}
