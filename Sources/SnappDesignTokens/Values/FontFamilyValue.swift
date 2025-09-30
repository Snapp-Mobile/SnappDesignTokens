//
//  FontFamilyValue.swift
//
//  Created by Volodymyr Voiko on 25.03.2025.
//

public struct FontFamilyValue: Codable, Equatable, Sendable, ExpressibleByStringLiteral {
    public let names: [String]

    public init(from decoder: any Decoder) throws {
        do {
            let names = try [String](from: decoder)
            self.init(names: names)
        } catch {
            let name = try String(from: decoder)
            self.init(name)
        }
    }

    public init(names: [String]) {
        self.names = names
    }

    public init(_ names: String...) {
        self.init(names: names)
    }

    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }

    public func encode(to encoder: any Encoder) throws {
        if names.count == 1 {
            try names[0].encode(to: encoder)
        } else {
            try names.encode(to: encoder)
        }
    }
}
