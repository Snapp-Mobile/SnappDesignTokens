//
//  CombineProcessor.swift
//
//  Created by Volodymyr Voiko on 09.04.2025.
//

public struct CombineProcessor: TokenProcessor {
    public let processors: [TokenProcessor]

    public init(processors: [TokenProcessor]) {
        self.processors = processors
    }

    public func process(_ token: Token) async throws -> Token {
        var transformedToken = token
        for processor in processors {
            transformedToken = try await processor.process(transformedToken)
        }
        return transformedToken
    }
}

extension TokenProcessor where Self == CombineProcessor {
    public static func combine(_ processors: TokenProcessor...) -> Self {
        .init(processors: processors)
    }
}

extension TokenProcessor {
    public func combine( _ other: TokenProcessor) -> TokenProcessor {
        .combine(self, other)
    }
}
