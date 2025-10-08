# ``NumberValue``

Represents a unitless numeric value.

## Overview

Used for line heights, gradient stop positions, opacity, and other unitless
measurements. Distinct from ``DimensionValue`` which includes units like px or rem.

## Examples

### Direct values

```swift
// Decodes from: {"$value": 1.5, "$type": "number"}
let lineHeight: NumberValue = 1.5

// Decodes from: {"$value": 0.8, "$type": "number"}
let opacity: NumberValue = 0.8

// Decodes from: {"$value": 0.25, "$type": "number"}
let gradientStop: NumberValue = 0.25
```

### JSON format

```json
{
  "line-height-large": {
    "$value": 1.5,
    "$type": "number"
  },
  "opacity-subtle": {
    "$value": 0.8,
    "$type": "number"
  },
  "gradient-stop-quarter": {
    "$value": 0.25,
    "$type": "number"
  }
}
```

## References

[Number token type documentation](https://www.designtokens.org/tr/third-editors-draft/format/#number)
