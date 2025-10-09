# ``FileValue``

Represents a file reference for external assets.

## Overview

References images, fonts, or other files using absolute URLs or relative paths.
Supports configurable encoding/decoding to resolve relative paths against a base URL.

## Examples

### Direct values

```swift
// Absolute URL
let image = FileValue(url: URL(string: "https://example.com/assets/logo.png")!)

// Relative path (will be resolved against base URL during decoding)
let icon = FileValue(url: URL(string: "/icons/star.svg")!)
```

### With base URL resolution

```swift
// Configure decoder with base URL
let config = FileValueDecodingConfiguration(
    sourceLocationURL: URL(string: "https://cdn.example.com")!
)

// Decoding with configuration resolves relative paths
// JSON: "/images/hero.jpg"
// Resolves to: "https://cdn.example.com/images/hero.jpg"
```

### Encoding formats

```swift
let file = FileValue(url: URL(string: "https://cdn.example.com/assets/image.png")!)

// Encode as absolute URL
let absoluteConfig = FileValueEncodingConfiguration(urlEncodingFormat: .absolute)
// Output: "https://cdn.example.com/assets/image.png"

// Encode as relative path
let relativeConfig = FileValueEncodingConfiguration(
    urlEncodingFormat: .relative(from: URL(string: "https://cdn.example.com")!)
)
// Output: "/assets/image.png"
```

### JSON format

```json
{
  "logo": {
    "$type": "file",
    "$value": "https://example.com/logo.png"
  },
  "icon": {
    "$type": "file",
    "$value": "/icons/menu.svg"
  },
  "avatar": {
    "$type": "file",
    "$value": "./images/user-avatar.png"
  }
}
```

## References

[File token type documentation (Additional Types)](https://www.designtokens.org/tr/third-editors-draft/format/#additional-types)
