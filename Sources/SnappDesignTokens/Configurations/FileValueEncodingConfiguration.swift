//
//  FileValueEncodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

public struct FileValueEncodingConfiguration: Equatable, Sendable {
    public static let `default`: Self = .init()

    public let urlEncodingFormat: FileValueURLEncodingFormat

    public init(urlEncodingFormat: FileValueURLEncodingFormat = .default) {
        self.urlEncodingFormat = urlEncodingFormat
    }
}
