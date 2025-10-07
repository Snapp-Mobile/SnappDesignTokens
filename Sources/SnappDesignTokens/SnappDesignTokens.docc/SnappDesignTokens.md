# ``SnappDesignTokens``

Framework for parsing and processing `DTCG` tokens.

@Metadata {
    @PageImage(purpose: icon, source:"logo")
}

## Overview

A Swift library for parsing and processing [DTCG-compliant](https://www.designtokens.org/tr/third-editors-draft/format/) design tokens into type-safe Swift structures.

[Clone on GitHub](https://github.com/Snapp-Mobile/SnappDesignTokens)

### Features

- **DTCG Compliance:** Full specification support
- **Token Types:** Color, Dimension, FontFamily, FontWeight, Duration, CubicBezier, Number, StrokeStyle, Border, Transition, Shadow, Gradient, Typography
- **Alias Resolution:** `{group.token}` references
- **Expression Evaluation:** Arithmetic operations in dimension values
- **Unit Conversion:** px ↔ rem
- **Processing Pipeline:** Composable token processors
- **Asset Caching:** Built-in file caching
- **Zero Dependencies:** Pure Swift implementation
- **Cross-Platform:** iOS, macOS, tvOS, watchOS, visionOS
