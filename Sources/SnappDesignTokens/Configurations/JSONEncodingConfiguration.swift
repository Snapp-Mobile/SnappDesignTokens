//
//  JSONEncodingConfiguration.swift
//
//  Created by Volodymyr Voiko on 08.04.2025.
//

import Foundation

/// Coding user info key for token encoding configuration.
private let encodingConfigurationKey = CodingUserInfoKey(
    rawValue: "TokenEncodingConfiguration"
)!

extension JSONEncoder {
    /// Token encoding configuration stored in user info.
    ///
    /// Defaults to ``TokenEncodingConfiguration/default`` when not set.
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
    /// Token encoding configuration from user info.
    ///
    /// Defaults to ``TokenEncodingConfiguration/default`` when not set.
    public var tokenEncodingConfiguration: TokenEncodingConfiguration {
        userInfo[encodingConfigurationKey] as? TokenEncodingConfiguration
            ?? .default
    }
}
