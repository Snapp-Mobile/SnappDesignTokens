# Expression Evaluation

Evaluate mathematical expressions in dimension token values.

@Metadata {
    @PageImage(purpose: icon, source:"operators")
}

## Overview

SnappDesignTokens includes built-in support for evaluating arithmetic expressions in dimension values, enabling dynamic calculations within design tokens. This allows tokens to reference and compute values based on other tokens or mathematical formulas.

Expression evaluation supports basic arithmetic operations (`+`, `-`, `*`, `/`) with parentheses for grouping, automatic unit conversion, and token alias references. The library provides two evaluation engines: an NSExpression-based evaluator and a custom recursive descent parser.

### When to Use Expression Evaluation

Use expressions when you need to:
- Calculate derived values from base tokens (e.g., `{spacing.base} * 2`)
- Create proportional spacing scales (e.g., `16px * 1.5`)
- Combine multiple values with arithmetic (e.g., `8px + 4px`)
- Define dynamic spacing or sizing systems

## Expression Structure

Expressions are parsed from strings into structured element arrays for evaluation. Each expression consists of ``DimensionExpressionElement`` values representing operations, dimension values, or token aliases.

### Expression Elements

The ``DimensionExpressionElement`` enum defines three types of elements:

```swift
// Dimension value
.value(DimensionConstant(value: 16, unit: .px))

// Arithmetic operation
.operation(.multiply)

// Token alias reference
.alias(TokenPath("spacing.base"))
```

### Supported Operations

The ``ArithmeticOperation`` enum defines all supported operations:

```swift
.add        // Addition (+)
.subtract   // Subtraction (-)
.multiply   // Multiplication (*)
.divide     // Division (/)
.leftParen  // Left parenthesis (()
.rightParen // Right parenthesis ())
```

## Parsing Expressions

Expressions are encoded as strings in JSON and decoded into ``DimensionExpression`` structures:

```swift
// JSON format
{
  "spacing-large": {
    "$type": "dimension",
    "$value": "16px * 1.5"
  }
}

// Decoded to DimensionExpression
let expression = DimensionExpression(elements: [
    .value(16, .px),
    .multiply,
    .value(1.5, .px)
])
```

### With Token Aliases

Expressions can reference other tokens using alias syntax:

```swift
// JSON with alias
{
  "spacing-double": {
    "$type": "dimension",
    "$value": "{spacing.base} * 2"
  }
}

// Decoded elements
[
    .alias(TokenPath("spacing.base")),
    .multiply,
    .value(2, .px)
]
```

## Evaluation Engines

The library provides two interchangeable evaluation engines conforming to ``DimensionValueEvaluator``.

### NSExpression Evaluator

``NSExpressionDimensionEvaluator`` uses Foundation's NSExpression for evaluation:

```swift
let evaluator = NSExpressionDimensionEvaluator(
    baseUnit: .px,
    converter: .default
)

let expression = DimensionExpression(elements: [
    .value(16, .px),
    .multiply,
    .value(1.5, .px)
])

let result = try evaluator.evaluate(expression)
// DimensionConstant(value: 24.0, unit: .px)
```

**Characteristics:**
- Uses Apple's battle-tested NSExpression engine
- Fast for simple expressions
- Platform-dependent (Foundation required)

### Arithmetic Expression Evaluator

``ArithmeticalExpressionEvaluator`` uses a custom recursive descent parser:

```swift
let evaluator = ArithmeticalExpressionEvaluator(
    baseUnit: .px,
    converter: .default
)

let result = try evaluator.evaluate(expression)
// DimensionConstant(value: 24.0, unit: .px)
```

**Characteristics:**
- Platform-independent implementation
- Full control over evaluation logic
- Stack overflow protection (configurable recursion limit)
- Managed by ``ArithmeticalExpressionManager``

## Unit Conversion

Before evaluation, all dimension values are converted to a common base unit using ``DimensionValueConverter``:

```swift
// Expression mixing units
let expression = DimensionExpression(elements: [
    .value(2, .rem),      // 2rem = 32px (assuming 16px base)
    .add,
    .value(8, .px)        // 8px
])

let result = try evaluator.evaluate(expression)
// DimensionConstant(value: 40.0, unit: .px)
```

The converter handles:
- Relative units (rem, em) → absolute (px)
- Percentage calculations
- Custom conversion ratios

## Error Handling

Expression evaluation can throw ``DimensionValueEvaluationError`` for various failure cases:

```swift
do {
    let result = try evaluator.evaluate(expression)
} catch DimensionValueEvaluationError.divisionByZero {
    // Handle division by zero
} catch DimensionValueEvaluationError.unresolvedAlias(let path) {
    // Handle unresolved token reference
} catch DimensionValueEvaluationError.invalidSyntax(let message) {
    // Handle malformed expression
}
```

### Common Errors

- `.emptyFormula` - Expression is empty
- `.invalidSyntax(_)` - Malformed expression syntax
- `.divisionByZero` - Attempted division by zero
- `.unresolvedAlias(_)` - Token reference cannot be resolved
- `.recursionLimitExceeded` - Expression too deeply nested

## Validation

Expressions are validated before evaluation using ``DefaultDimensionFormulaSyntax``:

```swift
let syntax = DefaultDimensionFormulaSyntax(formula: "16px * 1.5")
try syntax.isValidFormat()
```

Validation checks:
- Formula is not empty
- Length under 1000 characters (DoS protection)
- Contains only allowed characters
- No invalid character sequences

## Examples

### Basic Arithmetic

```swift
// Simple multiplication
let expression = DimensionExpression(elements: [
    .value(16, .px),
    .multiply,
    .value(1.5, .px)
])
// Result: 24px

// Addition
let spacing = DimensionExpression(elements: [
    .value(8, .px),
    .add,
    .value(4, .px)
])
// Result: 12px
```

### Complex Expressions

```swift
// Parentheses for grouping
let expression = DimensionExpression(elements: [
    .value(16, .px),
    .multiply,
    .operation(.leftParen),
    .value(1.5, .px),
    .add,
    .value(2, .px),
    .operation(.rightParen)
])
// Result: 16 * (1.5 + 2) = 56px
```

### Unit Mixing

```swift
// Combining rem and px
let expression = DimensionExpression(elements: [
    .value(2.5, .rem),    // 40px
    .add,
    .value(1.5, .rem)     // 24px
])
// Result: 64px (with 16px rem base)
```

## Topics

### Core Types
- ``DimensionExpression``
- ``DimensionExpressionElement``
- ``ArithmeticOperation``

### Evaluation
- ``DimensionValueEvaluator``
- ``NSExpressionDimensionEvaluator``
- ``ArithmeticalExpressionEvaluator``
- ``ArithmeticalExpressionManager``

### Conversion
- ``DimensionValueConverter``
- ``DefaultDimensionValueConverter``

### Errors
- ``DimensionValueEvaluationError``
- ``DimensionExpressionParsingError``
- ``DimensionExpressionElementParseError``

### Validation
- ``DimensionFormulaSyntax``
- ``DefaultDimensionFormulaSyntax``
