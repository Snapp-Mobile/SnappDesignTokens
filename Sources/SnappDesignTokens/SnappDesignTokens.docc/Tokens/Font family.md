# ``FontFamilyValue``

## Examples

### Direct values

```swift
// Decodes from: {"$value": "Comic Sans MS", "$type": "fontFamily"}
let primary: FontFamilyValue = "Comic Sans MS"

// Decodes from: {"$value": ["Helvetica", "Arial", "sans-serif"], "$type": "fontFamily"}
let body = FontFamilyValue("Helvetica", "Arial", "sans-serif")
```

### JSON format

```json
{
  "Primary font": {
    "$value": "Comic Sans MS",
    "$type": "fontFamily"
  },
  "Body font": {
    "$value": ["Helvetica", "Arial", "sans-serif"],
    "$type": "fontFamily"
  }
}
```

## References

[Font family token type documentation](https://www.designtokens.org/tr/third-editors-draft/format/#font-family)
