//
//  CubicBezierValue.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import Foundation

public struct CubicBezierValueDecodingError: Error, Equatable {
    public enum Reason: Equatable, Sendable {
        case incorrectNumberOfValues
        case xValueOutOfRange
    }
    
    public let values: [Double]
    public let reason: Reason

    public init(values: [Double], reason: Reason) {
        self.values = values
        self.reason = reason
    }
}

public struct CubicBezierValue: Equatable, Codable, Sendable {
    private static let xRange: ClosedRange<Double> = 0...1

    public let x1: Double
    public let y1: Double
    public let x2: Double
    public let y2: Double

    public init (x1: Double, y1: Double, x2: Double, y2: Double) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }

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

    public func encode(to encoder: any Encoder) throws {
        let values = [x1, y1, x2, y2]
        try values.encode(to: encoder)
    }
}
