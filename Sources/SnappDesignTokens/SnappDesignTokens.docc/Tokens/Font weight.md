# ``FontWeightValue``

Represents a font weight using numeric values or named aliases.

## Overview

Supports numeric values (1-1000) or named aliases like "bold" or "extra-light".
Decodes from either number or string. Values outside 1-1000 are rejected per
DTCG specification.

## Examples

### Direct values

```swift
// Decodes from: {"$value": 350, "$type": "fontWeight"}
let custom = FontWeightValue(rawValue: 350)!

// Decodes from: {"$value": "extra-bold", "$type": "fontWeight"}
let thick = FontWeightValue(alias: .extraBold)
```

### JSON format

```json
{
  "font-weight-default": {
    "$value": 350,
    "$type": "fontWeight"
  },
  "font-weight-thick": {
    "$value": "extra-bold",
    "$type": "fontWeight"
  }
}
```

## References

[Font weight token type documentation](https://www.designtokens.org/tr/third-editors-draft/format/#font-weight)
