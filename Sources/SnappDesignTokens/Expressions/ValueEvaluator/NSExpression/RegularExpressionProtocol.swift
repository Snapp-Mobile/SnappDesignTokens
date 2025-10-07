//
//  RegularExpressionProtocol.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

/// Protocol for creating regular expression instances.
///
/// Abstracts regular expression creation to enable dependency injection and testing.
public protocol RegularExpressionProtocol: Sendable {
    /// Creates a regular expression from a pattern string.
    ///
    /// - Parameter pattern: Regular expression pattern
    /// - Returns: Compiled regular expression
    /// - Throws: Error if pattern is invalid
    func expression(pattern: String) throws -> NSRegularExpression
}

/// Default implementation using Foundation's NSRegularExpression.
public struct RegularExpression: RegularExpressionProtocol {
    /// Creates a regular expression provider.
    public init() {

    }

    /// Creates a regular expression from a pattern string.
    ///
    /// - Parameter pattern: Regular expression pattern
    /// - Returns: Compiled NSRegularExpression
    /// - Throws: Error if pattern syntax is invalid
    public func expression(pattern: String) throws -> NSRegularExpression {
        try NSRegularExpression(pattern: pattern)
    }
}
