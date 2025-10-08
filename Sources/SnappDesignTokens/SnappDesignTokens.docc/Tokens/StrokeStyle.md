# ``StrokeStyleValue``

Represents stroke style applied to lines or borders.

## Overview

DTCG stroke style token supporting two formats: predefined line styles
(solid, dashed, dotted, etc.) or custom dash patterns with line cap control.
Follows CSS "line style" values with implementation-specificrendering.

## Examples

### Predefined line styles

```swift
// Simple line styles (string format)
let solid: StrokeStyleValue = .line(.solid)
let dashed: StrokeStyleValue = .line(.dashed)
let dotted: StrokeStyleValue = .line(.dotted)
let double: StrokeStyleValue = .line(.double)
```

### Custom dash patterns

```swift
// Custom dash pattern (object format)
let customDashed = StrokeStyleValue.dash(.init(
    dashArray: [
        .value(.constant(.init(value: 0.5, unit: .rem))),   // dash length
        .value(.constant(.init(value: 0.25, unit: .rem)))   // gap length
    ],
    lineCap: .round
))
```

### With token aliases

```swift
// Using alias reference in dash pattern
let alertBorder = StrokeStyleValue.dash(.init(
    dashArray: [
        .alias(TokenPath("dash-length-medium")),
        .value(.constant(.init(value: 0.25, unit: .rem)))
    ],
    lineCap: .butt
))
```

### JSON format

#### String format (predefined styles)

```json
{
  "border-solid": {
    "$type": "strokeStyle",
    "$value": "solid"
  },
  "border-dashed": {
    "$type": "strokeStyle",
    "$value": "dashed"
  },
  "border-dotted": {
    "$type": "strokeStyle",
    "$value": "dotted"
  }
}
```

#### Object format (custom dash patterns)

```json
{
  "focus-ring-style": {
    "$type": "strokeStyle",
    "$value": {
      "dashArray": [
        { "value": 0.5, "unit": "rem" },
        { "value": 0.25, "unit": "rem" }
      ],
      "lineCap": "round"
    }
  },
  "alert-border-style": {
    "$type": "strokeStyle",
    "$value": {
      "dashArray": [
        "{dash-length-medium}",
        { "value": 0.25, "unit": "rem" }
      ],
      "lineCap": "butt"
    }
  },
  "dash-length-medium": {
    "$type": "dimension",
    "$value": {
      "value": 10,
      "unit": "px"
    }
  }
}
```

## References

[Stroke Style token type documentation](https://www.designtokens.org/tr/third-editors-draft/format/#stroke-style)
