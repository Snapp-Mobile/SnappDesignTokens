//
//  FileValueDecodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

public struct FileValueDecodingConfiguration: Equatable, Sendable {
    public let sourceLocationURL: URL?

    public init(source sourceLocationURL: URL? = nil) {
        self.sourceLocationURL = sourceLocationURL
    }
}
