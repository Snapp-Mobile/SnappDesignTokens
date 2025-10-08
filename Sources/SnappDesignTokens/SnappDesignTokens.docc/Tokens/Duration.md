# ``DurationValue``

Represents a time duration for animations and transitions.

## Overview

Used for animation timing, transition delays, and other time-based values.
Specialization of ``TokenMeasurement`` for ``DurationUnit`` (seconds, milliseconds).

## Examples

### Direct values

```swift
// Decodes from: {"$value": {"value": 100, "unit": "ms"}, "$type": "duration"}
let quick = DurationValue(value: 100, unit: .millisecond)

// Decodes from: {"$value": {"value": 1.5, "unit": "s"}, "$type": "duration"}
let long = DurationValue(value: 1.5, unit: .second)
```

### JSON format

```json
{
  "duration-quick": {
    "$type": "duration",
    "$value": {
      "value": 100,
      "unit": "ms"
    }
  },
  "duration-long": {
    "$type": "duration",
    "$value": {
      "value": 1.5,
      "unit": "s"
    }
  }
}
```

## References

[Duration token type documentation](https://www.designtokens.org/tr/third-editors-draft/format/#duration)
