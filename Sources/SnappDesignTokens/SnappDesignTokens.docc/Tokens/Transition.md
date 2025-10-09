# ``TransitionValue``

Represents an animated transition between two states.

## Overview

Defines transition timing with duration, delay, and timing function. All properties
support direct values and token aliases.

## Examples

### Direct values

```swift
let emphasis = TransitionValue(
    duration: .value(DurationValue(value: 200, unit: .millisecond)),
    delay: .value(DurationValue(value: 0, unit: .millisecond)),
    timingFunction: .value(CubicBezierValue(x1: 0.5, y1: 0, x2: 1, y2: 1))
)
```

### With token aliases

```swift
let customTransition = TransitionValue(
    duration: .alias(TokenPath("animation.duration.normal")),
    delay: .value(DurationValue(value: 0, unit: .millisecond)),
    timingFunction: .alias(TokenPath("animation.easing.emphasis"))
)
```

### JSON format

```json
{
  "transition": {
    "emphasis": {
      "$type": "transition",
      "$value": {
        "duration": { "value": 200, "unit": "ms" },
        "delay": { "value": 0, "unit": "ms" },
        "timingFunction": [0.5, 0, 1, 1]
      }
    }
  }
}
```

## References

[Transition token type documentation](https://www.designtokens.org/tr/third-editors-draft/format/#transition)
