# ``GradientColor``

## Examples

### Direct values

```swift
// Complete gradient with stops
let blueToRed: GradientValue = [
    GradientColor(
        color: .value(ColorValue(colorSpace: .srgb, components: [.value(0), .value(0), .value(1)])),
        position: .value(0)
    ),
    GradientColor(
        color: .value(ColorValue(colorSpace: .srgb, components: [.value(1), .value(0), .value(0)])),
        position: .value(1)
    )
]
```

### With token aliases

```swift
// Using color alias reference
let brandGradient: GradientValue = [
    GradientColor(
        color: .alias(TokenPath("brand.primary")),
        position: .value(0)
    ),
    GradientColor(
        color: .alias(TokenPath("brand.secondary")),
        position: .value(1)
    )
]
```

### JSON format

```json
{
  "blue-to-red": {
    "$type": "gradient",
    "$value": [
      {
        "color": {
          "$type": "color",
          "$value": {
            "colorSpace": "srgb",
            "components": [0, 0, 1]
          }
        },
        "position": 0
      },
      {
        "color": {
          "$type": "color",
          "$value": {
            "colorSpace": "srgb",
            "components": [1, 0, 0]
          }
        },
        "position": 1
      }
    ]
  },
  "mostly-yellow": {
    "$type": "gradient",
    "$value": [
      {
        "color": {
          "$type": "color",
          "$value": {
            "colorSpace": "srgb",
            "components": [1, 1, 0]
          }
        },
        "position": 0.666
      },
      {
        "color": {
          "$type": "color",
          "$value": {
            "colorSpace": "srgb",
            "components": [1, 0, 0]
          }
        },
        "position": 1
      }
    ]
  }
}
```

## References

[Gradient token type documentation](https://www.designtokens.org/tr/third-editors-draft/format/#gradient)
