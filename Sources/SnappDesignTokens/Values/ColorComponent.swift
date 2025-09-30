//
//  ColorComponent.swift
//
//  Created by Volodymyr Voiko on 13.05.2025.
//

public enum ColorComponent: Equatable, Sendable, Codable {
    private static let noneKeyword = "none"

    case none
    case value(Double)

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let double = try container.decode(Double.self)
            self = .value(double)
        } catch {
            let string = try container.decode(String.self)
            guard string == Self.noneKeyword else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            "Invalid value: \(string)"
                    )
                )
            }
            self = .none
        }
    }

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .none:
            try Self.noneKeyword.encode(to: encoder)
        case .value(let double):
            try double.encode(to: encoder)
        }
    }
}

extension ColorComponent: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .value(value)
    }
}

extension ColorComponent: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(floatLiteral: Double(value))
    }
}
