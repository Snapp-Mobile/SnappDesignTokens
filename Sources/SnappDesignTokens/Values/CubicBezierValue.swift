//
//  CubicBezierValue.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import Foundation

/// Error thrown when decoding an invalid cubic Bézier curve.
public struct CubicBezierValueDecodingError: Error, Equatable {
    /// Reason for decoding failure.
    public enum Reason: Equatable, Sendable {
        /// Array doesn't contain exactly 4 values.
        case incorrectNumberOfValues

        /// X coordinate (x1 or x2) is outside the [0, 1] range.
        case xValueOutOfRange
    }

    /// The array of values that failed to decode.
    public let values: [Double]

    /// Specific reason for the decoding failure.
    public let reason: Reason

    /// Creates a decoding error with the specified values and reason.
    ///
    /// - Parameters:
    ///   - values: Array of values that failed to decode
    ///   - reason: Specific reason for failure
    public init(values: [Double], reason: Reason) {
        self.values = values
        self.reason = reason
    }
}

public struct CubicBezierValue: Equatable, Codable, Sendable {
    private static let xRange: ClosedRange<Double> = 0...1

    /// X coordinate of first control point (P1).
    ///
    /// Must be in range [0, 1].
    public let x1: Double

    /// Y coordinate of first control point (P1).
    ///
    /// Can be any real number.
    public let y1: Double

    /// X coordinate of second control point (P2).
    ///
    /// Must be in range [0, 1].
    public let x2: Double

    /// Y coordinate of second control point (P2).
    ///
    /// Can be any real number.
    public let y2: Double

    /// Creates a cubic Bézier curve with the specified control points.
    ///
    /// - Parameters:
    ///   - x1: X coordinate of first control point (must be 0-1)
    ///   - y1: Y coordinate of first control point
    ///   - x2: X coordinate of second control point (must be 0-1)
    ///   - y2: Y coordinate of second control point
    public init (x1: Double, y1: Double, x2: Double, y2: Double) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }

    /// Decodes a cubic Bézier curve from a 4-element array.
    ///
    /// Expects format `[x1, y1, x2, y2]` and validates constraints per DTCG specification.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: `DecodingError` if value is not an array or ``CubicBezierValueDecodingError`` if array length is invalid or X values out of range
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode([Double].self)

        guard values.count == 4 else {
            throw CubicBezierValueDecodingError(
                values: values,
                reason: .incorrectNumberOfValues
            )
        }

        guard
            Self.xRange.contains(values[0]),
            Self.xRange.contains(values[2])
        else {
            throw CubicBezierValueDecodingError(
                values: values,
                reason: .xValueOutOfRange
            )
        }

        x1 = values[0]
        x2 = values[2]

        y1 = values[1]
        y2 = values[3]
    }

    /// Encodes the curve as a 4-element array `[x1, y1, x2, y2]`.
    ///
    /// - Parameter encoder: Encoder to write data to
    /// - Throws: Error if encoding fails
    public func encode(to encoder: any Encoder) throws {
        let values = [x1, y1, x2, y2]
        try values.encode(to: encoder)
    }
}
