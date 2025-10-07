# ``BorderValue``

## Examples

### Direct values

```swift
let border = BorderValue(
    color: .value(.red),
    width: .value(.constant(.init(value: 3, unit: .px))),
    style: .value(.line(.solid))
)
```

### With token aliases

```swift
let focusRing = BorderValue(
    color: .alias("{color.focusring}"),
    width: .value(.constant(.init(value: 1, unit: .px))),
    style: .value(.dashed(/* ... */))
)
```

### JSON format

```json
"border": {
    "heavy": {
      "$type": "border",
      "$value": {
        "color": {
          "$type": "color",
          "$value": {
            "colorSpace": "srgb",
            "components": [0.218, 0.218, 0.218]
          }
        },
        "width": {
          "value": 3,
          "unit": "px"
        },
        "style": "solid"
      }
    },
    "focusring": {
      "$type": "border",
      "$value": {
        "color": "{color.focusring}",
        "width": {
          "value": 1,
          "unit": "px"
        },
        "style": {
          "dashArray": [
            { "value": 0.5, "unit": "rem" },
            { "value": 0.25, "unit": "rem" }
          ],
          "lineCap": "round"
        }
      }
    }
  }
}
```

## References

[Border composite token type documentation](https://www.designtokens.org/tr/third-editors-draft/format/#border)
