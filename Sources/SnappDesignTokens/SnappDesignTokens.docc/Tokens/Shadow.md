# ``ShadowValue``

## Examples

### Single shadow

```swift
// Drop shadow
let dropShadow = ShadowValue(
    color: .value(try ColorValue(hex: "#000000")),
    offsetX: .value(.constant(.init(value: 2, unit: .px))),
    offsetY: .value(.constant(.init(value: 4, unit: .px))),
    blur: .value(.constant(.init(value: 8, unit: .px))),
    spread: .value(.constant(.init(value: 0, unit: .px)))
)
```

### Inner shadow with alias

```swift
let innerShadow = ShadowValue(
    color: .alias(TokenPath("shadow.inner.color")),
    offsetX: .value(.constant(.init(value: 0, unit: .px))),
    offsetY: .value(.constant(.init(value: 2, unit: .px))),
    blur: .value(.constant(.init(value: 4, unit: .px))),
    spread: .value(.constant(.init(value: -1, unit: .px))),
    inset: true
)
```

### Layered shadows

```swift
// Multiple shadows can be combined in an array
let layered: [ShadowValue] = [
    ShadowValue(
        color: .value(ColorValue(colorSpace: .srgb, components: [.value(0), .value(0), .value(0)], alpha: 0.1)),
        offsetX: .value(.constant(.init(value: 0, unit: .px))),
        offsetY: .value(.constant(.init(value: 24, unit: .px))),
        blur: .value(.constant(.init(value: 22, unit: .px))),
        spread: .value(.constant(.init(value: 0, unit: .px)))
    ),
    ShadowValue(
        color: .value(ColorValue(colorSpace: .srgb, components: [.value(0), .value(0), .value(0)], alpha: 0.2)),
        offsetX: .value(.constant(.init(value: 0, unit: .px))),
        offsetY: .value(.constant(.init(value: 42.9, unit: .px))),
        blur: .value(.constant(.init(value: 44, unit: .px))),
        spread: .value(.constant(.init(value: 0, unit: .px)))
    )
]
```

### JSON format

```json
{
  "shadow-token": {
    "$type": "shadow",
    "$value": {
      "color": {
        "$type": "color",
        "$value": {
          "colorSpace": "srgb",
          "components": [0, 0, 0],
          "alpha": 0.5
        }
      },
      "offsetX": { "value": 0.5, "unit": "rem" },
      "offsetY": { "value": 0.5, "unit": "rem" },
      "blur": { "value": 1.5, "unit": "rem" },
      "spread": { "value": 0, "unit": "rem" }
    }
  },
  "layered-shadow": {
    "$type": "shadow",
    "$value": [
      {
        "color": {
          "$type": "color",
          "$value": {
            "colorSpace": "srgb",
            "components": [0, 0, 0],
            "alpha": 0.1
          }
        },
        "offsetX": { "value": 0, "unit": "px" },
        "offsetY": { "value": 24, "unit": "px" },
        "blur": { "value": 22, "unit": "px" },
        "spread": { "value": 0, "unit": "px" }
      },
      {
        "color": {
          "$type": "color",
          "$value": {
            "colorSpace": "srgb",
            "components": [0, 0, 0],
            "alpha": 0.2
          }
        },
        "offsetX": { "value": 0, "unit": "px" },
        "offsetY": { "value": 42.9, "unit": "px" },
        "blur": { "value": 44, "unit": "px" },
        "spread": { "value": 0, "unit": "px" }
      }
    ]
  },
  "inner-shadow": {
    "$type": "shadow",
    "$value": {
      "color": {
        "$type": "color",
        "$value": {
          "colorSpace": "srgb",
          "components": [0, 0, 0],
          "alpha": 0.5
        }
      },
      "offsetX": { "value": 2, "unit": "px" },
      "offsetY": { "value": 2, "unit": "px" },
      "blur": { "value": 4, "unit": "px" },
      "spread": { "value": 0, "unit": "px" },
      "inset": true
    }
  }
}
```

## References

[Shadow token type documentation](https://www.designtokens.org/tr/third-editors-draft/format/#shadow)
