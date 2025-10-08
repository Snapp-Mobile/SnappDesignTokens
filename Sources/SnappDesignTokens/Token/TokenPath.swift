//
//  TokenPath.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

/// Error thrown when parsing token reference paths.
public enum TokenPathParsingError: String, Error, LocalizedError, Equatable {
    /// Token reference path is not properly enclosed in curly braces.
    case bracketsMismatch = "Alias value must be enclosed in curly braces"

    /// Token reference path is empty after removing braces.
    case emptyAlias = "Alias value cannot be empty"

    public var errorDescription: String? { rawValue }

    public static func == (
        lhs: TokenPathParsingError,
        rhs: TokenPathParsingError
    ) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

/// Represents a token reference path in DTCG format.
///
/// Token references use the syntax `{group.token}` to reference other token values.
/// The path is period-separated and represents the hierarchical location of the target token.
///
/// ### Example
/// ```swift
/// // From string literal
/// let path = TokenPath(from: "{color.primary}")
///
/// // From path components
/// let path = TokenPath("color", "primary")
/// let path = TokenPath(["color", "primary"])
///
/// // Encodes as: "{color.primary}"
/// ```
public struct TokenPath: Decodable, Encodable, Hashable, RawRepresentable,
    Sendable
{
    private static let separator = "."

    private static let openingBracket = "{"
    private static let closingBracket = "}"

    /// Path components representing the hierarchical token location.
    public var paths: [String]

    /// DTCG-formatted reference string with curly braces (e.g., `"{color.primary}"`).
    public var rawValue: String {
        Self.openingBracket + paths.joined(separator: Self.separator) + Self.closingBracket
    }

    /// Creates a token path from an array of path components.
    ///
    /// - Parameter paths: Path components (e.g., `["color", "primary"]`)
    public init(_ paths: [String] = []) {
        self.paths = paths
    }

    /// Creates a token path from variadic path components.
    ///
    /// - Parameter paths: Path components (e.g., `"color", "primary"`)
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

    /// Creates a token path by parsing a DTCG reference string.
    ///
    /// Parses strings in the format `{group.token}` or `{group.subgroup.token}`.
    /// The path must be enclosed in curly braces and contain at least one path component.
    ///
    /// - Parameter stringValue: DTCG reference string (e.g., `"{color.primary}"`)
    /// - Throws: ``TokenPathParsingError/bracketsMismatch`` if braces are invalid
    /// - Throws: ``TokenPathParsingError/emptyAlias`` if path is empty
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

    /// Appends a path component in place.
    ///
    /// - Parameter path: Path component to append
    public mutating func append(_ path: String) {
        paths.append(path)
    }

    /// Returns a new path with the component appended.
    ///
    /// - Parameter path: Path component to append
    /// - Returns: New path with appended component
    public func appending(_ path: String) -> TokenPath {
        var copy = self
        copy.append(path)
        return copy
    }

    public func encode(to encoder: any Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}
