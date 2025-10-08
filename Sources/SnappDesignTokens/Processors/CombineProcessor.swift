//
//  CombineProcessor.swift
//
//  Created by Volodymyr Voiko on 09.04.2025.
//

/// Processor that chains multiple processors sequentially.
///
/// Executes processors in order, passing output of each processor as input
/// to the next. Enables building complex processing pipelines from simple
/// reusable components.
///
/// ### Example
/// ```swift
/// let processor: TokenProcessor = .combine(
///     .resolveAliases,
///     .arithmeticalEvaluation,
///     .dimensionValueConversion(targetUnit: .rem),
///     .flatten(pathConversionStrategy: .dotSeparated)
/// )
/// let result = try await processor.process(token)
/// ```
public struct CombineProcessor: TokenProcessor {
    /// Array of processors to execute sequentially.
    public let processors: [TokenProcessor]

    /// Creates a combine processor.
    ///
    /// - Parameter processors: Array of processors to chain
    public init(processors: [TokenProcessor]) {
        self.processors = processors
    }

    /// Processes token through all processors sequentially.
    ///
    /// Each processor receives the output of the previous processor. Returns
    /// final transformed token after all processors complete.
    ///
    /// - Parameter token: Token tree to process
    /// - Returns: Token tree after all processors have been applied
    /// - Throws: Error from any processor in the chain
    public func process(_ token: Token) async throws -> Token {
        var transformedToken = token
        for processor in processors {
            transformedToken = try await processor.process(transformedToken)
        }
        return transformedToken
    }
}

extension TokenProcessor where Self == CombineProcessor {
    /// Creates a combine processor from variadic processor arguments.
    ///
    /// - Parameter processors: Processors to chain sequentially
    /// - Returns: ``CombineProcessor`` executing processors in order
    public static func combine(_ processors: TokenProcessor...) -> Self {
        .init(processors: processors)
    }
}

extension TokenProcessor {
    /// Chains this processor with another processor.
    ///
    /// - Parameter other: Processor to execute after this processor
    /// - Returns: Combined processor executing both in sequence
    public func combine( _ other: TokenProcessor) -> TokenProcessor {
        .combine(self, other)
    }
}
