//
//  ArithmeticalExpressionManager.swift
//
//  Created by Oleksii Kolomiiets on 10.03.2025.
//

import Foundation

/// Protocol for numeric types supporting arithmetic operations.
///
/// Enables generic mathematical expression evaluation across different numeric types.
public protocol Numeric {
    /// Adds two values.
    static func + (lhs: Self, rhs: Self) -> Self

    /// Subtracts right value from left value.
    static func - (lhs: Self, rhs: Self) -> Self

    /// Multiplies two values.
    static func * (lhs: Self, rhs: Self) -> Self

    /// Divides left value by right value.
    static func / (lhs: Self, rhs: Self) -> Self

    /// Checks equality of two values.
    static func == (lhs: Self, rhs: Self) -> Bool

    /// Creates a value from a Double.
    init(_ value: Double)
}

extension Double: Numeric {}

/// Evaluates mathematical expressions using recursive descent parsing.
///
/// Parses and evaluates arithmetic formulas with support for addition, subtraction,
/// multiplication, division, parentheses, and unary operators. Includes protections
/// against stack overflow and division by zero.
final public class ArithmeticalExpressionManager<T: Numeric> {
    private var formula: String
    private var position: Int = 0
    private var currentChar: Character?
    private var recursionDepth: Int = 0
    private let maxRecursionDepth: Int
    private let doubleFromString: DoubleFromStringProtocol

    init(
        formula: String,
        maxRecursionDepth: Int = 100,
        doubleFromString: DoubleFromStringProtocol = DoubleFromString()
    ) {
        // Sanitize input by removing all whitespace
        self.formula = formula.replacingOccurrences(of: " ", with: "")
        self.maxRecursionDepth = maxRecursionDepth
        if !self.formula.isEmpty {
            self.currentChar = self.formula[self.formula.startIndex]
        }
        self.doubleFromString = doubleFromString
    }

    // Advances to the next character
    private func advance() {
        position += 1
        if position < formula.count {
            let index = formula.index(formula.startIndex, offsetBy: position)
            currentChar = formula[index]
        } else {
            currentChar = nil
        }
    }

    // Check recursion depth to prevent stack overflow attacks
    private func checkRecursionDepth() throws(DimensionValueEvaluationError) {
        recursionDepth += 1
        if recursionDepth > maxRecursionDepth {
            throw .recursionLimitExceeded
        }
    }

    // Release recursion depth
    private func releaseRecursionDepth() {
        recursionDepth -= 1
    }

    /// Evaluates the formula and returns the result.
    ///
    /// Validates syntax using ``DefaultDimensionFormulaSyntax``, then parses and evaluates
    /// the expression using recursive descent parsing.
    ///
    /// - Returns: Evaluated numeric result
    /// - Throws: ``DimensionValueEvaluationError`` if syntax is invalid, recursion limit exceeded, or division by zero occurs
    public func evaluate() throws(DimensionValueEvaluationError) -> T {
        let syntaxChecker = DefaultDimensionFormulaSyntax(formula: formula)
        try syntaxChecker.isValidFormat()

        // If validation passes, proceed with evaluation
        let result = try expression()

        // Check if we've processed the entire formula
        if currentChar != nil {
            throw .invalidSyntax("Unexpected character at position \(position)")
        }

        return result
    }

    // Grammar rule: expression -> term ((+|-) term)*
    private func expression() throws(DimensionValueEvaluationError) -> T {
        try checkRecursionDepth()
        defer { releaseRecursionDepth() }

        var result = try term()

        while currentChar != nil && (currentChar == "+" || currentChar == "-") {
            let op = currentChar!
            advance()
            let right = try term()

            if op == "+" {
                result = result + right
            } else {
                result = result - right
            }
        }

        return result
    }

    // Grammar rule: term -> factor ((*|/) factor)*
    private func term() throws(DimensionValueEvaluationError) -> T {
        try checkRecursionDepth()
        defer { releaseRecursionDepth() }

        var result = try factor()

        while currentChar != nil && (currentChar == "*" || currentChar == "/") {
            let op = currentChar!
            advance()
            let right = try factor()

            if op == "*" {
                result = result * right
            } else {
                if right == T(0) {
                    throw .divisionByZero
                }
                result = result / right
            }
        }

        return result
    }

    // Grammar rule: factor -> number | (-) factor | (+) factor | ( expression )
    private func factor() throws(DimensionValueEvaluationError) -> T {
        try checkRecursionDepth()
        defer { releaseRecursionDepth() }

        // Handle unary minus
        if currentChar == "-" {
            advance()
            return T(0) - (try factor())
        }

        // Handle unary plus (just ignore it)
        if currentChar == "+" {
            advance()
            return try factor()
        }

        // Handle parentheses
        if currentChar == "(" {
            advance() // Consume '('
            let result = try expression() // Parse the expression inside parentheses

            // After parsing the expression, we expect a closing parenthesis
            if currentChar != ")" {
                throw .invalidSyntax("Expected closing parenthesis at position \(position)")
            }

            advance() // Consume ')'
            return result
        }

        // Handle numbers
        return try number()
    }

    // Parse a number
    private func number() throws(DimensionValueEvaluationError) -> T {
        var numStr = ""
        var decimalPointFound = false

        // Process digits and decimal point
        while currentChar != nil && (currentChar!.isNumber || currentChar == ".") {
            if currentChar == "." {
                if decimalPointFound {
                    throw .invalidSyntax("Multiple decimal points in number")
                }
                decimalPointFound = true
            }

            numStr.append(currentChar!)
            advance()
        }

        if numStr.isEmpty {
            throw .invalidCharacter(currentChar ?? Character(" "), position: position)
        }

        if let doubleValue = doubleFromString.double(numStr) {
            // Check for potential overflow or underflow
            if doubleValue.isInfinite || doubleValue.isNaN {
                throw .numberOutOfRange
            }
            return T(doubleValue)
        } else {
            throw .invalidSyntax("Invalid number format: \(numStr)")
        }
    }
}
