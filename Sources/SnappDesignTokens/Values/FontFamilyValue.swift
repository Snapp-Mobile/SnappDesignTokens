//
//  FontFamilyValue.swift
//
//  Created by Volodymyr Voiko on 25.03.2025.
//

// swift-format-ignore: AllPublicDeclarationsHaveDocumentation
// Reason: Documentation is in `FontFamily.md`
public struct FontFamilyValue: Codable, Equatable, Sendable, ExpressibleByStringLiteral {
    /// Font names ordered from most to least preferred.
    public let names: [String]

    /// Decodes a font family from single string or array.
    ///
    /// Attempts array decoding first, falling back to single string.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: `DecodingError` if value is neither string nor string array
    public init(from decoder: any Decoder) throws {
        do {
            let names = try [String](from: decoder)
            self.init(names: names)
        } catch {
            let name = try String(from: decoder)
            self.init(name)
        }
    }

    /// Creates a font family with the specified names.
    ///
    /// - Parameter names: Font names ordered by preference
    public init(names: [String]) {
        self.names = names
    }

    /// Creates a font family from variadic names.
    ///
    /// - Parameter names: Font names ordered by preference
    public init(_ names: String...) {
        self.init(names: names)
    }

    /// Creates a font family from a string literal.
    ///
    /// Enables syntax like: `let font: FontFamilyValue = "Helvetica"`
    ///
    /// - Parameter value: Font name
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }

    /// Encodes as single string or array based on count.
    ///
    /// Single font encodes as string, multiple fonts encode as array.
    ///
    /// - Parameter encoder: Encoder to write data to
    /// - Throws: Error if encoding fails
    public func encode(to encoder: any Encoder) throws {
        if names.count == 1 {
            try names[0].encode(to: encoder)
        } else {
            try names.encode(to: encoder)
        }
    }
}
