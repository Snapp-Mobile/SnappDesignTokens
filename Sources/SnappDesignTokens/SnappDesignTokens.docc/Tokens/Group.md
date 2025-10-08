# ``TokenGroup``

Collection of design tokens organized hierarchically.

## Overview

Provides organizational structure with nested groups. Supports type inheritance
where child tokens inherit `$type` from parent group if not explicitly set.

## Examples

### Basic grouping

```swift
let colors: TokenGroup = [
    "primary": .value(.color(ColorValue(colorSpace: .srgb, components: [.value(0), .value(0.5), .value(1)]))),
    "secondary": .value(.color(ColorValue(colorSpace: .srgb, components: [.value(0.5), .value(0), .value(1)])))
]
```

### Nested groups

```swift
let tokens: TokenGroup = [
    "colors": .group([
        "primary": .value(.color(ColorValue(hex: "#0080FF"))),
        "shades": .group([
            "light": .value(.color(ColorValue(hex: "#66B3FF"))),
            "dark": .value(.color(ColorValue(hex: "#0059B3")))
        ])
    ]),
    "spacing": .group([
        "small": .value(.dimension(.constant(.init(value: 8, unit: .px)))),
        "medium": .value(.dimension(.constant(.init(value: 16, unit: .px))))
    ])
]
```

### Type inheritance

Groups can specify a `$type` that child tokens inherit:

```swift
// JSON with type inheritance
{
  "colors": {
    "$type": "color",
    "primary": {
      "$value": {"colorSpace": "srgb", "components": [0, 0.5, 1]}
    },
    "secondary": {
      "$value": {"colorSpace": "srgb", "components": [0.5, 0, 1]}
    }
  }
}
```

In this example, both `primary` and `secondary` inherit `$type: "color"` from the parent group, so they don't need to specify it individually.

### JSON format

```json
{
  "colors": {
    "primary": {
      "$type": "color",
      "$value": {
        "colorSpace": "srgb",
        "components": [0.07, 0.07, 0.07]
      }
    }
  },
  "spacing": {
    "$type": "dimension",
    "small": {
      "$value": { "value": 8, "unit": "px" }
    },
    "medium": {
      "$value": { "value": 16, "unit": "px" }
    },
    "large": {
      "$value": { "value": 24, "unit": "px" }
    }
  },
  "nested": {
    "group": {
      "deeply": {
        "nested": {
          "token": {
            "$value": 42,
            "$type": "number"
          }
        }
      }
    }
  }
}
```

## References

[Groups documentation](https://www.designtokens.org/tr/third-editors-draft/format/#groups)
