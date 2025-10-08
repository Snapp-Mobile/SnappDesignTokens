//
//  FileValue.swift
//
//  Created by Ilian Konchev on 5.03.25.
//

import Foundation
import UniformTypeIdentifiers

/// Error thrown when decoding an invalid file URL.
public enum FileValueDecodingError: Error {
    /// String cannot be parsed as a valid URL.
    case invalidURL(String)
}

/// URL encoding format for file values.
///
/// Controls whether file paths are encoded as absolute URLs or relative paths.
public enum FileValueURLEncodingFormat: Equatable, Sendable {
    /// Default encoding format (absolute URLs).
    public static let `default`: Self = .absolute

    /// Relative path encoding without base URL.
    public static let relative: Self = .relative(from: nil)

    /// Absolute URL format (e.g., `"https://example.com/image.png"`).
    case absolute

    /// Relative path format, optionally relative to a base URL.
    ///
    /// - When `from` is `nil`: Encodes as relative path (e.g., `"/images/image.png"`)
    /// - When `from` is specified: Encodes relative to base URL (e.g., `"/image.png"`)
    case relative(from: URL?)
}

public struct FileValue: DecodableWithConfiguration, Decodable,
    EncodableWithConfiguration, Encodable,
    Equatable, Sendable
{
    /// URL referencing the file (absolute or relative).
    public let url: URL

    /// Creates a file value with the specified URL.
    ///
    /// - Parameter url: File URL (absolute or relative path)
    public init(url: URL) {
        self.url = url
    }

    /// Decodes a file value from a URL string with optional configuration.
    ///
    /// Resolves relative paths against the source location URL if provided in configuration.
    /// URLs without host/scheme are treated as relative and resolved against the base.
    ///
    /// - Parameters:
    ///   - decoder: Decoder to read data from
    ///   - configuration: Optional configuration with source location for resolving relative paths
    /// - Throws: `DecodingError` if value is not a string or ``FileValueDecodingError/invalidURL(_:)`` if string is not a valid URL
    public init(
        from decoder: any Decoder,
        configuration: FileValueDecodingConfiguration?
    ) throws {
        let container = try decoder.singleValueContainer()
        let urlString = try container.decode(String.self)

        guard var url = URL(string: urlString) else {
            throw FileValueDecodingError.invalidURL(urlString)
        }

        if url.host == nil || url.scheme == nil {
            url =
                configuration?.sourceLocationURL.map {
                    $0.appending(path: url.relativePath)
                } ?? url
        }

        self.url = url
    }

    /// Decodes a file value using the decoder's configuration.
    ///
    /// - Parameter decoder: Decoder to read data from
    /// - Throws: ``FileValueDecodingError`` if decoding fails
    public init(from decoder: any Decoder) throws {
        try self.init(
            from: decoder,
            configuration: decoder.tokenDecodingConfiguration
                .fileDecodingConfiguration
        )
    }

    /// Encodes the file value with the specified configuration.
    ///
    /// - Parameters:
    ///   - encoder: Encoder to write data to
    ///   - configuration: URL encoding format (absolute or relative)
    /// - Throws: `EncodingError.invalidValue` if URL cannot be encoded in the specified format
    public func encode(
        to encoder: any Encoder,
        configuration: FileValueEncodingConfiguration
    ) throws {
        switch configuration.urlEncodingFormat {
        case .absolute:
            try url.absoluteString.encode(to: encoder)
        case .relative(.none):
            try url.relativePath.encode(to: encoder)
        case .relative(.some(let sourceLocationURL)):
            let absoluteString = url.absoluteString
            let sourceLocationAbsoluteString = sourceLocationURL.absoluteString
            guard absoluteString.hasPrefix(sourceLocationAbsoluteString) else {
                throw EncodingError.invalidValue(
                    url,
                    EncodingError.Context(
                        codingPath: encoder.codingPath,
                        debugDescription:
                            "URL \(url) is not relative to \(sourceLocationURL)"
                    )
                )
            }
            let relativePath = String(
                absoluteString.trimmingPrefix("\(sourceLocationAbsoluteString)")
            )
            try relativePath.encode(to: encoder)
        }
    }

    /// Encodes the file value using the encoder's configuration.
    ///
    /// - Parameter encoder: Encoder to write data to
    /// - Throws: Error if encoding fails
    public func encode(to encoder: any Encoder) throws {
        try self.encode(
            to: encoder,
            configuration: encoder.tokenEncodingConfiguration
                .tokenValueEncodingConfiguration?.fileEncodingConfiguration
                ?? .default
        )
    }
}
