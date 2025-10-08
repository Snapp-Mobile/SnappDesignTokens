# ``ColorValue``

Represents a color across different color spaces.

## Overview

Supports 13+ color spaces including sRGB, Display P3, HSL, Lab, and more.
Can decode from hex strings (e.g., `"#FF0000"`) or structured format with
explicit color space and components. Components support numeric values or
``ColorComponent/none`` for missing channels.

## Examples

### Hex string format

```swift
// Decodes from: {"$value": "#FF0000", "$type": "color"}
let red = try ColorValue(hex: "#FF0000")
```

### Structured format

```swift
// HSL with "none" component
let hslWhite = ColorValue(
    colorSpace: .hsl,
    components: [.none, .value(0), .value(100)],
    alpha: 1,
    hex: "#ffffff"
)

// Lab color space
let labMagenta = ColorValue(
    colorSpace: .lab,
    components: [.value(60.17), .value(93.54), .value(-60.5)],
    hex: "#ff00ff"
)
```

### JSON format

```json
{
  "Hot pink": {
    "$type": "color",
    "$value": {
      "colorSpace": "srgb",
      "components": [1, 0, 1],
      "alpha": 1,
      "hex": "#ff00ff"
    }
  },
  "Translucent shadow": {
    "$type": "color",
    "$value": {
      "colorSpace": "srgb",
      "components": [0, 0, 0],
      "alpha": 0.5,
      "hex": "#000000"
    }
  }
}
```

## References

[Color token type documentation](https://www.designtokens.org/tr/third-editors-draft/format/#color)
