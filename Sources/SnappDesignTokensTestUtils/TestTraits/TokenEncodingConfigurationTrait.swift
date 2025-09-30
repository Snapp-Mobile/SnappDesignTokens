//
//  TokenEncodingConfigurationTrait.swift
//
//  Created by Volodymyr Voiko on 08.04.2025.
//

import SnappDesignTokens
import Foundation
import Testing

@TaskLocal public var dtcgJSONEncoder = {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys]
    return encoder
}()

public struct TokenEncodingConfigurationTrait: TestTrait, TestScoping {
    let configuration: TokenEncodingConfiguration
    let outputFormatting: JSONEncoder.OutputFormatting

    public func provideScope(
        for test: Test,
        testCase: Test.Case?,
        performing function: @Sendable () async throws -> Void
    ) async throws {
        let configuredEncoder = JSONEncoder()
        configuredEncoder.outputFormatting = outputFormatting
        configuredEncoder.tokenEncodingConfiguration = configuration
        try await $dtcgJSONEncoder.withValue(configuredEncoder) {
            try await function()
        }
    }
}

extension Trait where Self == TokenEncodingConfigurationTrait {
    public static func dtcgEncoder(
        with configuration: TokenEncodingConfiguration = .default,
        outputFormatting: JSONEncoder.OutputFormatting = dtcgJSONEncoder.outputFormatting
    ) -> Self {
        Self(configuration: configuration, outputFormatting: outputFormatting)
    }
}
