# ``TypographyValue``

Represents a complete typographic style.

## Overview

Combines five text-related properties: font family, size, weight, letter spacing,
and line height. All properties support direct values and token aliases.

## Examples

### Direct values

```swift
let heading = TypographyValue(
    fontFamily: .value(FontFamilyValue("Roboto")),
    fontSize: .value(.constant(.init(value: 42, unit: .px))),
    fontWeight: .value(FontWeightValue(rawValue: 700)!),
    letterSpacing: .value(.constant(.init(value: 0.1, unit: .px))),
    lineHeight: .value(1.2)
)
```

### With token aliases

```swift
let microcopy = TypographyValue(
    fontFamily: .alias(TokenPath("font.serif")),
    fontSize: .alias(TokenPath("font.size.smallest")),
    fontWeight: .alias(TokenPath("font.weight.normal")),
    letterSpacing: .value(.constant(.init(value: 0, unit: .px))),
    lineHeight: .value(1)
)
```

### JSON format

```json
{
  "type styles": {
    "heading-level-1": {
      "$type": "typography",
      "$value": {
        "fontFamily": "Roboto",
        "fontSize": {
          "value": 42,
          "unit": "px"
        },
        "fontWeight": 700,
        "letterSpacing": {
          "value": 0.1,
          "unit": "px"
        },
        "lineHeight": 1.2
      }
    },
    "microcopy": {
      "$type": "typography",
      "$value": {
        "fontFamily": "{font.serif}",
        "fontSize": "{font.size.smallest}",
        "fontWeight": "{font.weight.normal}",
        "letterSpacing": {
          "value": 0,
          "unit": "px"
        },
        "lineHeight": 1
      }
    }
  }
}
```

## References

[Typography token type documentation](https://www.designtokens.org/tr/third-editors-draft/format/#typography)
