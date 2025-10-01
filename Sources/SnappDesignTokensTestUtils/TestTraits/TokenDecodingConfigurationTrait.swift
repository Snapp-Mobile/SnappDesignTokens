//
//  TokenDecodingConfigurationTrait.swift
//
//  Created by Volodymyr Voiko on 08.04.2025.
//

import SnappDesignTokens
import Foundation
import Testing

@TaskLocal var dtcgJSONDecoder = JSONDecoder()

struct TokenDecodingConfigurationTrait: TestTrait, TestScoping {
    let configuration: TokenDecodingConfiguration

    func provideScope(
        for test: Test,
        testCase: Test.Case?,
        performing function: @Sendable () async throws -> Void
    ) async throws {
        let configuredDecoder = JSONDecoder()
        configuredDecoder.tokenDecodingConfiguration = configuration
        try await $dtcgJSONDecoder.withValue(configuredDecoder) {
            try await function()
        }
    }
}

extension Trait where Self == TokenDecodingConfigurationTrait {
    static func dtcgDecoder(
        with configuration: TokenDecodingConfiguration
    ) -> Self {
        Self(configuration: configuration)
    }
}
