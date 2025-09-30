//
//  StrokeStyleValue.swift
//
//  Created by Volodymyr Voiko on 01.04.2025.
//

import Foundation

public enum StrokeStyleValue: Codable, Equatable, Sendable, CompositeToken {
    public enum LineStyle: String, Codable, Equatable, Sendable {
        case solid
        case dashed
        case dotted
        case double
        case groove
        case ridge
        case outset
        case inset
    }

    public enum LineCap: String, Codable, Equatable, Sendable {
        case round
        case butt
        case square
    }

    public struct DashPattern: Codable, Equatable, Sendable, CompositeToken {
        public let dashArray: [CompositeTokenValue<DimensionValue>]
        public let lineCap: LineCap

        public mutating func resolveAliases(root: Token) throws {
            self = try .init(
                dashArray: dashArray.map {
                    try $0.resolvingAliases(root: root)
                },
                lineCap: lineCap
            )
        }
    }

    case line(LineStyle)
    case dash(DashPattern)

    public init(from decoder: any Decoder) throws {
        do {
            self = .line(try LineStyle(from: decoder))
        } catch {
            self = .dash(try DashPattern(from: decoder))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .line(let lineStyle):
            try lineStyle.encode(to: encoder)
        case .dash(let dashPattern):
            try dashPattern.encode(to: encoder)
        }
    }

    public mutating func resolveAliases(root: Token) throws {
        guard case .dash(var pattern) = self else { return }
        try pattern.resolveAliases(root: root)
        self = .dash(pattern)
    }
}
