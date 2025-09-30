//
//  UnknownToken.swift
//
//  Created by Volodymyr Voiko on 19.03.2025.
//

import Foundation

public struct UnknownToken: RawRepresentable, Codable, Equatable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String?

    public init(rawValue: String?) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }

    public init(from decoder: any Decoder) throws {
        self.init(rawValue: try? String(from: decoder))
    }
}
