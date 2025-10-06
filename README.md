<div style="text-align: center;">
  <img src="Sources/SnappDesignTokens/SnappDesignTokens.docc/Resources/logo.png" alt="SnappTheming logo" width="128"/>
</div>
<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2016%2B%20%7C%20macOS%2013%2B-blue.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Swift-6.1-orange.svg" alt="Swift">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
</p>

# SnappDesignTokens

A Swift library for parsing and processing [DTCG-compliant](https://www.designtokens.org/tr/third-editors-draft/format/) design tokens into type-safe Swift structures.

## Contents
- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
  - [Loading Design Tokens](#loading-design-tokens)
  - [Processing Pipelines](#processing-pipelines)
  - [Working with Token Values](#working-with-token-values)
  - [Alias Resolution](#alias-resolution)
  - [Expression Evaluation](#expression-evaluation)
  - [Unit Conversion](#unit-conversion)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Features

- ✅ Full DTCG format specification compliance
- 🎨 Support for all primitive token types (Color, Dimension, FontFamily, FontWeight, Duration, CubicBezier, Number)
- 🧩 Support for composite token types (StrokeStyle, Border, Transition, Shadow, Gradient, Typography)
- 🔗 Token alias resolution with `{group.token}` syntax
- 🧮 Dimension expression evaluation with arithmetic operations
- 📐 Unit conversion (px ↔ rem)
- 🔄 Flexible token processing pipeline
- 💾 Built-in file asset caching
- ⚡️ Zero external dependencies
- 📱 Cross-platform support (iOS, macOS, tvOS, watchOS, visionOS)

## Requirements

- iOS 16.0+ / macOS 13.0+
- Swift 6.1+
- Xcode 16.0+

## Installation

### Swift Package Manager

Add SnappDesignTokens to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/Snapp-Mobile/SnappDesignTokens.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File > Add Package Dependencies...
2. Enter package URL: `https://github.com/Snapp-Mobile/SnappDesignTokens.git`
3. Select version and add to your target

## Quick Start

```swift
import SnappDesignTokens
import Foundation

// Load and parse DTCG-compliant JSON file
let url = Bundle.main.url(forResource: "tokens", withExtension: "json")!
let data = try Data(contentsOf: url)

let decoder = JSONDecoder()
let token = try decoder.decode(Token.self, from: data)

// Access token values
if case .group(let group) = token,
   case .value(.color(let colorValue)) = group["brand.primary"] {
    print("Brand color: \(colorValue.hex)")
}
```

## Usage

### Loading Design Tokens

```swift
let jsonData = """
{
  "color": {
    "base": {
      "red": { "$value": "#FF0000", "$type": "color" },
      "blue": { "$value": "#0000FF", "$type": "color" }
    }
  }
}
""".data(using: .utf8)!

let decoder = JSONDecoder()
let token = try decoder.decode(Token.self, from: jsonData)
```

### Processing Pipelines

```swift
// Resolve aliases and flatten hierarchy
let processedToken = try await CombineProcessor.combine(
    .resolveAliases,
    .flatten()
).process(token)

// Alternative syntax
let processedToken = try await ResolveAliasesTokenProcessor
    .resolveAliases
    .combine(.flatten())
    .process(token)
```

### Working with Token Values

```swift
// Color tokens
if case .color(let color) = token.value {
    print("Hex: \(color.hex)")
    print("RGB: \(color.components)")
    print("Alpha: \(color.alpha)")
}

// Dimension tokens
if case .dimension(let dimension) = token.value {
    print("Value: \(dimension.value)")
    print("Unit: \(dimension.unit)") // .px, .rem, etc.
}

// Typography tokens
if case .typography(let typography) = token.value {
    print("Font: \(typography.fontFamily)")
    print("Size: \(typography.fontSize)")
    print("Weight: \(typography.fontWeight)")
}
```

### Alias Resolution

```swift
let jsonData = """
{
  "base": {
    "color1": { "$value": "#FF0000", "$type": "color" },
    "color2": { "$value": "{base.color1}" }
  }
}
""".data(using: .utf8)!

let token: Token = try jsonData.decode()
let resolved = try await ResolveAliasesTokenProcessor
    .resolveAliases
    .process(token)

// base.color2 now contains #FF0000
```

### Expression Evaluation

```swift
let jsonData = """
{
  "space1": { "$value": "2*2", "$type": "dimension" },
  "space2": { "$value": "2", "$type": "dimension" }
}
""".data(using: .utf8)!

let token: Token = try jsonData.decode()

// Using arithmetical evaluation
let evaluated = try await DimensionValueEvaluationProcessor
    .arithmeticalEvaluation
    .process(token)

// space1 is now 4

// Or using NSExpression-based evaluation
let evaluated = try await DimensionValueEvaluationProcessor
    .expressionsEvaluation
    .process(token)
```

### Unit Conversion

```swift
let token: Token = .group([
    "dimension1": .value(.dimension(.constant(.init(value: 160, unit: .px)))),
    "dimension2": .value(.dimension(.constant(.init(value: 1, unit: .rem))))
])

let processor: DimensionValueConversionProcessor = .dimensionValueConversion(
    using: .converter(with: 16), // 1rem = 16px
    targetUnit: .rem
)

let converted = try await processor.process(token)
// dimension1 is now 10rem, dimension2 remains 1rem
```

## Documentation

For more information about the DTCG specification, visit [Design Tokens Community Group Format Specification](https://www.designtokens.org/tr/third-editors-draft/format/).

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

SnappDesignTokens is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
