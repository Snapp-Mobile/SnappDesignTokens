//
//  JSONDecodingConfiguration.swift
//
//  Created by Volodymyr Voiko on 08.04.2025.
//

import Foundation

/// Coding user info key for token decoding configuration.
private let decodingConfigurationKey = CodingUserInfoKey(
    rawValue: "TokenDecodingConfiguration"
)!

extension JSONDecoder {
    /// Token decoding configuration stored in user info.
    ///
    /// Defaults to ``TokenDecodingConfiguration/default`` when not set.
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
    /// Token decoding configuration from user info.
    ///
    /// Defaults to ``TokenDecodingConfiguration/default`` when not set.
    public var tokenDecodingConfiguration: TokenDecodingConfiguration {
        userInfo[decodingConfigurationKey] as? TokenDecodingConfiguration
            ?? .default
    }
}
