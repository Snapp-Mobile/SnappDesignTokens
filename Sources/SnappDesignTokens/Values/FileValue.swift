//
//  FileValue.swift
//
//  Created by Ilian Konchev on 5.03.25.
//

import Foundation
import UniformTypeIdentifiers

public enum FileValueDecodingError: Error {
    case invalidURL(String)
}

public enum FileValueURLEncodingFormat: Equatable, Sendable {
    public static let `default`: Self = .absolute
    public static let relative: Self = .relative(from: nil)

    case absolute
    case relative(from: URL?)
}

public struct FileValue: DecodableWithConfiguration, Decodable,
    EncodableWithConfiguration, Encodable,
    Equatable, Sendable
{
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

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

    public init(from decoder: any Decoder) throws {
        try self.init(
            from: decoder,
            configuration: decoder.tokenDecodingConfiguration
                .fileDecodingConfiguration
        )
    }

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

    public func encode(to encoder: any Encoder) throws {
        try self.encode(
            to: encoder,
            configuration: encoder.tokenEncodingConfiguration
                .tokenValueEncodingConfiguration?.fileEncodingConfiguration
                ?? .default
        )
    }
}
