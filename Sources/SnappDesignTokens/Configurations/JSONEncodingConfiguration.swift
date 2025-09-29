//
//  JSONEncodingConfiguration.swift
//
//  Created by Volodymyr Voiko on 08.04.2025.
//

import Foundation

private let encodingConfigurationKey = CodingUserInfoKey(
    rawValue: "TokenEncodingConfiguration"
)!

extension JSONEncoder {
    public var tokenEncodingConfiguration: TokenEncodingConfiguration {
        get {
            userInfo[encodingConfigurationKey]
                as? TokenEncodingConfiguration ?? .default
        }
        set {
            userInfo[encodingConfigurationKey] = newValue
        }
    }
}

extension Encoder {
    public var tokenEncodingConfiguration: TokenEncodingConfiguration {
        userInfo[encodingConfigurationKey] as? TokenEncodingConfiguration
            ?? .default
    }
}
