# Token Processors

Transform design token trees through composable pipeline operations.

## Overview

Token processors provide a modular architecture for transforming design token trees after parsing. Each processor performs a specific transformation—resolving aliases, evaluating expressions, converting units, or flattening hierarchies. Processors implement the ``TokenProcessor`` protocol and can be chained sequentially to build complex transformation pipelines.

The processing pipeline follows a typical sequence: parse JSON → resolve token aliases → evaluate mathematical expressions → convert dimension units → flatten nested structures. Each step transforms the token tree, passing its output to the next processor. This composable design enables flexible token transformations while keeping individual processors simple and focused.

All processors support Swift concurrency with `async`/`throws` signatures and `Sendable` conformance, enabling safe concurrent token processing in modern Swift applications.

### When to Use Processors

Use token processors when you need to:
- Convert token aliases into their actual values before exporting
- Evaluate mathematical expressions in dimension tokens to produce computed values
- Standardize all dimensions to a single unit (e.g., convert everything to `rem`)
- Flatten nested token groups into flat key-value structures
- Filter out internal or deprecated tokens before delivery
- Cache processed results for performance optimization

## Built-in Processors

SnappDesignTokens provides several processors for common token transformations.

### Resolve Aliases

``ResolveAliasesTokenProcessor`` resolves all token references (`{group.token}` syntax) to their actual values, following reference chains until reaching concrete values.

```swift
// Tokens with aliases: { "base": { "color": "#FF0000" }, "theme": { "primary": "{base.color}" } }

let processor: TokenProcessor = .resolveAliases
let resolved = try await processor.process(token)
// Result: { "base": { "color": "#FF0000" }, "theme": { "primary": "#FF0000" } }
```

This processor traverses the entire token tree recursively, replacing all ``CompositeTokenValue/alias(_:)`` references with their resolved values. If an alias references another alias, resolution continues until reaching a concrete value. Circular references are detected and reported as errors.

### Flatten Hierarchy

``FlattenProcessor`` converts nested token groups into a flat dictionary structure, combining group paths into token keys. This is useful for exporting tokens to platforms that don't support hierarchical organization.

```swift
// Nested tokens: { "colors": { "brand": { "primary": "#FF0000" } } }

let processor: TokenProcessor = .flatten(pathConversionStrategy: .dotSeparated)
let flattened = try await processor.process(token)
// Result: { "colors.brand.primary": "#FF0000" }
```

The processor supports three path conversion strategies:
- **Dot-separated** (`.dotSeparated`): Joins paths with periods (`colors.brand.primary`)
- **Snake case** (`.convertToSnakeCase`): Converts to underscore notation (`colors_brand_primary`)
- **Camel case** (`.convertToCamelCase`): Converts to camel case (`colorsBrandPrimary`)

```swift
// Using different strategies
let snakeCase: TokenProcessor = .flatten(pathConversionStrategy: .convertToSnakeCase)
// Produces: colors_brand_primary

let camelCase: TokenProcessor = .flatten(pathConversionStrategy: .convertToCamelCase)
// Produces: colorsBrandPrimary
```

### Evaluate Expressions

``DimensionValueEvaluationProcessor`` evaluates mathematical expressions in dimension tokens, computing constant values from formulas. See <doc:ExpressionEvaluation> for detailed expression syntax and capabilities.

```swift
// Tokens with expressions: { "spacing": "16px * 1.5", "margin": "8px + 4px" }

let processor: TokenProcessor = .arithmeticalEvaluation
let evaluated = try await processor.process(token)
// Result: { "spacing": "24px", "margin": "12px" }
```

This processor supports two evaluation engines: ``NSExpressionDimensionEvaluator`` (default) and ``ArithmeticalExpressionEvaluator``. Both handle standard arithmetic operations (`+`, `-`, `*`, `/`), unit conversion, and nested parentheses.

```swift
// Using custom evaluator
let customProcessor: TokenProcessor = .dimensionValueEvaluation(
    using: ArithmeticalExpressionEvaluator()
)
```

The processor recursively evaluates all dimension expressions in the token tree, including those in composite token types like ``TypographyValue`` (fontSize, letterSpacing).

### Convert Units

``DimensionValueConversionProcessor`` converts all dimension values to a target unit, standardizing mixed-unit token sets.

```swift
// Tokens with mixed units: { "spacing": "16px", "margin": "1rem", "padding": "0.5em" }

let processor: TokenProcessor = .dimensionValueConversion(targetUnit: .rem)
let converted = try await processor.process(token)
// Result: { "spacing": "1rem", "margin": "1rem", "padding": "0.5rem" }
```

The processor uses ``DimensionValueConverter`` for unit calculations, applying conversion ratios defined in the converter. Both constant dimensions and expression elements are converted.

```swift
// Convert to pixels
let pxProcessor: TokenProcessor = .dimensionValueConversion(targetUnit: .px)

// Using custom converter
let customProcessor: TokenProcessor = .dimensionValueConversion(
    using: CustomConverter(baseFontSize: 18.0),
    targetUnit: .rem
)
```

### Skip Keys

``SkipKeysProcessor`` removes specified keys from the root token group, filtering out unwanted metadata or internal tokens before export.

```swift
// Tokens with metadata: { "$schema": "...", "$metadata": {...}, "colors": {...} }

let processor: TokenProcessor = .skipKeys("$schema", "$metadata", "_internal")
let filtered = try await processor.process(token)
// Result: { "colors": {...} }
```

This processor only processes the root level token group. Nested groups are unaffected. Use variadic string arguments or pass an array of key names.

```swift
// Using array syntax
let keys = ["$schema", "$metadata", "$deprecated"]
let processor: TokenProcessor = .skipKeys(keys)
```

### Cache Files

``FileCachingProcessor`` downloads and caches remote file assets referenced in file tokens, replacing remote URLs with local file paths.

```swift
let manager = AssetsManager(themeName: "myTheme")
let processor = FileCachingProcessor(assetsManager: manager)
let cached = try await processor.process(token)
// File tokens now reference local cached files
```

This processor is typically used internally by the framework when loading tokens with file references. File downloads are asynchronous, and failed downloads are logged without stopping processing. The original token is preserved if download fails.

## Combining Processors

``CombineProcessor`` chains multiple processors sequentially, executing each in order and passing the output of one as input to the next.

```swift
let pipeline: TokenProcessor = .combine(
    .resolveAliases,
    .arithmeticalEvaluation,
    .dimensionValueConversion(targetUnit: .rem),
    .flatten(pathConversionStrategy: .dotSeparated)
)
let result = try await pipeline.process(token)
```

Processor order matters because each transformation builds on previous results:

1. **Resolve aliases first** – Later processors need actual values, not references
2. **Evaluate expressions** – Produces concrete values for unit conversion
3. **Convert units** – Standardizes dimensions before flattening
4. **Flatten last** – Works on fully resolved, evaluated token tree

```swift
// Using combine method syntax
let pipeline = ResolveAliasesTokenProcessor.resolveAliases
    .combine(.arithmeticalEvaluation)
    .combine(.flatten())
```

### Error Handling

Any processor in the chain can throw errors, stopping pipeline execution immediately. Handle errors when processing to catch issues like circular alias references or invalid expressions.

```swift
do {
    let result = try await pipeline.process(token)
    // Process successful result
} catch let error as AliasResolutionError {
    // Handle alias resolution failures
} catch let error as ExpressionEvaluationError {
    // Handle expression evaluation failures
} catch {
    // Handle other processing errors
}
```

## Custom Processors

Create custom processors by conforming to ``TokenProcessor`` protocol. Processors must implement a single async method that transforms a token tree.

```swift
struct FilterDeprecatedProcessor: TokenProcessor {
    func process(_ token: Token) async throws -> Token {
        token.map { element in
            guard case .group(var group) = element else {
                return element
            }
            // Remove tokens with $deprecated property
            group = group.filter { _, value in
                // Custom filtering logic
                return !isDeprecated(value)
            }
            return .group(group)
        }
    }
}
```

### Implementation Guidelines

When implementing custom processors:

- **Immutability**: Never mutate the input token. Always return a new transformed token.
- **Recursion**: Use ``Token/map(_:)`` to recursively traverse the token tree.
- **Sendable**: Ensure all captured values are thread-safe for Swift concurrency.
- **Performance**: Minimize allocations and avoid unnecessary tree traversals.
- **Error handling**: Throw descriptive errors for transformation failures.

```swift
struct ScaleDimensionsProcessor: TokenProcessor {
    let scale: Double

    func process(_ token: Token) async throws -> Token {
        guard scale > 0 else {
            throw ProcessingError.invalidScale(scale)
        }

        return token.map { element in
            guard case .value(.dimension(.constant(let dimension))) = element else {
                return element
            }

            let scaled = DimensionValue(
                value: dimension.value * scale,
                unit: dimension.unit
            )
            return .value(.dimension(.constant(scaled)))
        }
    }
}
```

## Common Patterns

### Standard Export Pipeline

Most export workflows follow this pattern: resolve references, evaluate calculations, standardize units, flatten structure.

```swift
let exportPipeline: TokenProcessor = .combine(
    .skipKeys("$schema", "$metadata"),
    .resolveAliases,
    .arithmeticalEvaluation,
    .dimensionValueConversion(targetUnit: .rem),
    .flatten(pathConversionStrategy: .dotSeparated)
)

let tokens = try await TokenLoader.load(from: url)
let exported = try await exportPipeline.process(tokens)
```

### Conditional Processing

Apply processors conditionally based on token content or platform requirements.

```swift
func createPlatformProcessor(platform: Platform) -> TokenProcessor {
    let baseProcessors: [TokenProcessor] = [
        .resolveAliases,
        .arithmeticalEvaluation
    ]

    switch platform {
    case .web:
        return .combine(baseProcessors + [
            .dimensionValueConversion(targetUnit: .rem),
            .flatten(pathConversionStrategy: .dotSeparated)
        ])
    case .ios:
        return .combine(baseProcessors + [
            .dimensionValueConversion(targetUnit: .pt),
            .flatten(pathConversionStrategy: .convertToCamelCase)
        ])
    case .android:
        return .combine(baseProcessors + [
            .dimensionValueConversion(targetUnit: .dp),
            .flatten(pathConversionStrategy: .convertToSnakeCase)
        ])
    }
}
```

### Testing Processors

Test processors independently before combining them into pipelines.

```swift
func testResolveAliases() async throws {
    let input = Token.group([
        "base": .group(["color": .value(.color(.red))]),
        "theme": .group(["primary": .alias("base.color")])
    ])

    let processor: TokenProcessor = .resolveAliases
    let result = try await processor.process(input)

    guard case .group(let groups) = result,
          case .group(let theme) = groups["theme"],
          case .value(.color(.red)) = theme["primary"] else {
        XCTFail("Alias not resolved correctly")
        return
    }
}
```

## Best Practices

### Processor Ordering

Follow this general order for maximum effectiveness:

1. **Filter unwanted keys** (``SkipKeysProcessor``) – Remove metadata early
2. **Resolve aliases** (``ResolveAliasesTokenProcessor``) – Eliminate references before computation
3. **Evaluate expressions** (``DimensionValueEvaluationProcessor``) – Compute values before conversion
4. **Convert units** (``DimensionValueConversionProcessor``) – Standardize before flattening
5. **Flatten hierarchy** (``FlattenProcessor``) – Final structural transformation

### Performance Considerations

- **Cache pipeline results**: Reuse processed tokens instead of re-processing
- **Avoid redundant processors**: Don't include processors that won't transform anything
- **Process once**: Combine multiple transformations into single pipeline rather than applying processors separately
- **Profile custom processors**: Measure performance impact of complex transformations

### Error Recovery

Design processors to handle partial failures gracefully when appropriate.

```swift
struct TolerantProcessor: TokenProcessor {
    func process(_ token: Token) async throws -> Token {
        token.map { element in
            do {
                return try transform(element)
            } catch {
                // Log error but preserve original token
                logger.warning("Failed to transform token: \(error)")
                return element
            }
        }
    }
}
```

## Topics

### Processor Protocol
- ``TokenProcessor``

### Combining Processors
- ``CombineProcessor``

### Alias Resolution
- ``ResolveAliasesTokenProcessor``

### Structure Transformation
- ``FlattenProcessor``
- ``SkipKeysProcessor``

### Dimension Processing
- ``DimensionValueEvaluationProcessor``
- ``DimensionValueConversionProcessor``

### File Handling
- ``FileCachingProcessor``

### Related Documentation
- <doc:ExpressionEvaluation>
- ``Token``
- ``DimensionValue``
