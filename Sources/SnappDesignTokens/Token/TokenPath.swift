//
//  TokenPath.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

public enum TokenPathParsingError: String, Error, LocalizedError, Equatable {
    case bracketsMismatch = "Alias value must be enclosed in curly braces"
    case emptyAlias = "Alias value cannot be empty"

    public var errorDescription: String? { rawValue }

    public static func == (
        lhs: TokenPathParsingError,
        rhs: TokenPathParsingError
    ) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

public struct TokenPath: Decodable, Encodable, Hashable, RawRepresentable,
    Sendable
{
    private static let separator = "."

    private static let openingBracket = "{"
    private static let closingBracket = "}"

    public var paths: [String]

    public var rawValue: String {
        Self.openingBracket + paths.joined(separator: Self.separator) + Self.closingBracket
    }

    public init(_ paths: [String] = []) {
        self.paths = paths
    }

    public init(_ paths: String...) {
        self.init(paths)
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)

        do {
            try self.init(from: stringValue)
        } catch {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Invalid format",
                    underlyingError: error
                )
            )
        }
    }

    public init?(rawValue: String) {
        try? self.init(from: rawValue)
    }

    public init(from stringValue: String) throws {
        var rawString =
            stringValue
            .trimmingCharacters(in: .whitespacesAndNewlines)

        let startsWithOpeningBracket = rawString.hasPrefix(Self.openingBracket)
        let endsWithClosingBracket = rawString.hasSuffix(Self.closingBracket)
        let startsAndEndsWithBrackets = startsWithOpeningBracket && endsWithClosingBracket
        
        let openBracketsCount = rawString.count(where: { String($0) == Self.openingBracket })
        let closeBracketsCount = rawString.count(where: { String($0) == Self.closingBracket })
        let hasSingleOpenAndCloseBracket = openBracketsCount == 1 && closeBracketsCount == 1

        guard
            startsAndEndsWithBrackets,
            hasSingleOpenAndCloseBracket
        else {
            throw TokenPathParsingError.bracketsMismatch
        }

        rawString.replace(Self.openingBracket, with: "")
        rawString.replace(Self.closingBracket, with: "")

        guard !rawString.isEmpty else {
            throw TokenPathParsingError.emptyAlias
        }

        if rawString.contains(Self.separator) {
            self.paths = rawString.split(separator: Self.separator).map(String.init)
        } else {
            self.paths = [rawString]
        }
    }

    public mutating func append(_ path: String) {
        paths.append(path)
    }

    public func appending(_ path: String) -> TokenPath {
        var copy = self
        copy.append(path)
        return copy
    }

    public func encode(to encoder: any Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}
