# ``FontWeightValue``

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
