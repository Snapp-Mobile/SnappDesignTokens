# DesignTokens

@Metadata {
    @PageImage(purpose: icon, source:"dtcg_logo")
}

Parse and work with Design Tokens Community Group (DTCG) format files in Swift.

## Overview

SnappDesignTokens implements the DTCG specification for design tokens, enabling type-safe parsing and manipulation of design token files in Swift applications.

Design tokens are name/value pairs that store design decisions (colors, spacing, typography, etc.) in a platform-agnostic format. This library reads DTCG-compliant JSON files and converts them into Swift data structures.

### Supported Token Types

The library supports all DTCG token types, organized into primitive and composite categories:

#### Primitive Types

Primitive tokens have singular values:

- ``ColorValue`` - Colors across different color spaces (sRGB, Display P3, HSL, Lab, etc.)
- ``DimensionValue`` - Measurements with units (px, rem, em, etc.)
- ``FontFamilyValue`` - Font family names with optional fallbacks
- ``FontWeightValue`` - Font weights (numeric or named aliases)
- ``DurationValue`` - Time durations for animations (seconds, milliseconds)
- ``CubicBezierValue`` - Animation timing curves
- ``NumberValue`` - Unitless numeric values

#### Composite Types

Composite tokens combine multiple sub-values in pre-defined structures:

- ``BorderValue`` - Border styling with color, width, and stroke style
- ``ShadowValue`` - Drop and inner shadows with color, offsets, and blur
- ``GradientValue`` - Color gradients with multiple stops
- ``TransitionValue`` - Animation transitions with duration, delay, and timing
- ``TypographyValue`` - Complete typographic styles
- ``StrokeStyleValue`` - Stroke patterns for borders and outlines

### Key Features

- **Type-safe parsing**: Converts JSON to strongly-typed Swift structures
- **Token aliases**: Supports `{group.token}` reference syntax
- **Alias resolution**: Resolves token references to actual values
- **Expression evaluation**: Evaluates mathematical expressions in dimension values (e.g., `"16px * 1.5"`, `"{spacing.base} * 2"`)
- **Processing pipeline**: Modular processors for transforming token trees (resolve aliases, evaluate expressions, convert units, flatten hierarchies)
- **Comprehensive validation**: Type checking per DTCG specification
- **Extensions support**: Handles `$extensions` for custom metadata

## Topics

### Primitive Types

- ``ColorValue``
- ``DimensionValue``
- ``FontFamilyValue``
- ``FontWeightValue``
- ``DurationValue``
- ``CubicBezierValue``
- ``NumberValue``
- ``FileValue``

### Composite Types

- ``BorderValue``
- ``ShadowValue``
- ``GradientValue``
- ``TransitionValue``
- ``TypographyValue``
- ``StrokeStyleValue``
