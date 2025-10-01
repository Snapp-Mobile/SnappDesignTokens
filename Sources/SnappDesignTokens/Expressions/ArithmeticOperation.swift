//
//  ArithmeticOperation.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

/// Arithmetic operators and parentheses for dimension expressions.
///
/// Represents mathematical operations and grouping symbols used in DTCG
/// dimension expression evaluation.
///
/// Example:
/// ```swift
/// let expr = [
///     .value(.init(value: 16, unit: .px)),
///     .operation(.multiply),
///     .operation(.leftParen),
///     .value(.init(value: 1.5, unit: .px)),
///     .operation(.add),
///     .value(.init(value: 2, unit: .px)),
///     .operation(.rightParen)
/// ]  // 16 * (1.5 + 2) = 56
/// ```
public enum ArithmeticOperation: String, Decodable, CaseIterable, Equatable, Sendable {
    /// Addition operator (`+`).
    case add = "+"

    /// Subtraction operator (`-`).
    case subtract = "-"

    /// Multiplication operator (`*`).
    case multiply = "*"

    /// Division operator (`/`).
    case divide = "/"

    /// Left parenthesis for grouping (`(`).
    case leftParen = "("

    /// Right parenthesis for grouping (`)`).
    case rightParen = ")"
}
