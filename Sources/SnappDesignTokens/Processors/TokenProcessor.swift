//
//  TokenProcessor.swift
//
//  Created by Volodymyr Voiko on 03.03.2025.
//

/// Protocol for transforming token trees.
///
/// Defines a pipeline-based architecture for processing design tokens. Processors
/// can resolve aliases, flatten hierarchies, evaluate expressions, or perform
/// custom transformations. Multiple processors can be combined sequentially.
///
/// Built-in processors:
/// - ``ResolveAliasesTokenProcessor`` - Resolves all token aliases
/// - ``FlattenProcessor`` - Flattens nested token groups
/// - ``DimensionValueEvaluationProcessor`` - Evaluates dimension expressions
/// - ``DimensionValueConversionProcessor`` - Converts dimension units
/// - ``CombineProcessor`` - Chains multiple processors
///
/// ### Example
/// ```swift
/// let processor: TokenProcessor = .combine(
///     .resolveAliases,
///     .flatten(pathConversionStrategy: .dotSeparated)
/// )
/// let processed = try await processor.process(token)
/// ```
public protocol TokenProcessor: Sendable {
    /// Processes a token tree, returning a transformed result.
    ///
    /// Implementations should not mutate the input token. Return a new token
    /// with transformations applied.
    ///
    /// - Parameter token: Token tree to process
    /// - Returns: Transformed token tree
    /// - Throws: Processing error if transformation fails
    func process(_ token: Token) async throws -> Token
}
