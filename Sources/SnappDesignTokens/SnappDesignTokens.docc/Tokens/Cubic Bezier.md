# ``CubicBezierValue``

Represents a cubic Bézier animation timing curve.

## Overview

Defines how an animated property progresses using two control points.
Decodes from 4-element array `[x1, y1, x2, y2]` where X coordinates must be
in range [0, 1] and Y coordinates can be any real number.

## Examples

### Direct values

```swift
// Decodes from: {"$value": [0.5, 0, 1, 1], "$type": "cubicBezier"}
let accelerate = CubicBezierValue(x1: 0.5, y1: 0, x2: 1, y2: 1)

// Decodes from: {"$value": [0, 0, 0.5, 1], "$type": "cubicBezier"}
let decelerate = CubicBezierValue(x1: 0, y1: 0, x2: 0.5, y2: 1)
```

### JSON format

```json
{
  "Accelerate": {
    "$value": [0.5, 0, 1, 1],
    "$type": "cubicBezier"
  },
  "Decelerate": {
    "$value": [0, 0, 0.5, 1],
    "$type": "cubicBezier"
  }
}
```

## References

[Cubic Bézie token type documentation](https://www.designtokens.org/tr/third-editors-draft/format/#cubic-bezier)
