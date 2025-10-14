//
//  ArithmeticalExpressionManagerTests.swift
//
//  Created by Oleksii Kolomiiets on 05.03.2025.
//

import Foundation
import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct ArithmeticalExpressionManagerTests {
    // MARK: - Basic Arithmetic Tests
    @Test(arguments: [
        ("2+3", 5.0),
        ("10+20", 30.0),
        ("0+0", 0.0),
        ("-5+3", -2.0),
    ])
    func testAddition(formula: String, expected value: Double) throws {
        #expect(try evaluateFormula(formula) == value)
    }

    @Test(arguments: [
        ("5-3", 2.0),
        ("20-10", 10.0),
        ("0-0", 0.0),
        ("-5-3", -8.0),
    ])
    func testSubtraction(formula: String, expected value: Double) throws {
        #expect(try evaluateFormula(formula) == value)
    }

    @Test(arguments: [
        ("2*3", 6.0),
        ("10*20", 200.0),
        ("0*5", 0.0),
        ("-5*3", -15.0),
    ])
    func testMultiplication(formula: String, expected value: Double) throws {
        #expect(try evaluateFormula(formula) == value)
    }

    @Test(arguments: [
        ("6/2", 3.0),
        ("10/5", 2.0),
        ("0/5", 0.0),
        ("-10/2", -5.0),
    ])
    func testDivision(formula: String, expected value: Double) throws {
        #expect(try evaluateFormula(formula) == value)
    }

    // MARK: - Decimal Number Tests
    @Test(arguments: [
        ("3.14+2.0", 5.14),
        ("10.5*2", 21.0),
        ("6.0/2.0", 3.0),
        ("0.5+0.5", 1.0),
    ])
    func testDecimalNumbers(formula: String, expected value: Double) throws {
        #expect(try evaluateFormula(formula).roundedToFourDecimalPlaces() == value)
    }

    // MARK: - Invalid Expression Tests
    @Test(arguments: [
        // Invalid characters
        "abc",
        "1+a",
        "++",
        "--",
        "//",
        "**",
        "2**3",
        "3**2",
        "0**5",
        "-5**3",
    ])
    func testInvalidExpressions(formula: String) throws {
        do {
            let _ = try evaluateFormula(formula)
            Issue.record()
        } catch {
            if case .invalidCharacter(let char, position: let p) = error {
                #expect(error == .invalidCharacter(char, position: p))
            } else {
                Issue.record(error)
            }
        }
    }

    // MARK: - Whitespace Handling Tests
    @Test(arguments: [
        ("2 + 3", 5.0),
        (" 2+3 ", 5.0),
        ("10 * 20", 200.0),
    ])
    func testWhitespaceHandling(formula: String, expected value: Double) throws {
        #expect(try evaluateFormula(formula) == value)
    }

    // MARK: - Negative Number Tests
    @Test(arguments: [
        ("-5+3", -2.0),
        ("5*-3", -15.0),
        ("-10/-2", 5.0),
    ])
    func testNegativeNumbers(formula: String, expected value: Double) throws {
        #expect(try evaluateFormula(formula) == value)
    }

    // MARK: - Mixed Operator Tests
    @Test(arguments: [
        ("2+3.0*4.0-5.0/2.0", 11.5),
        ("10/2+3*2-4", 7.0),
        ("1+2*3-4/2", 5.0),
    ])
    func testMixedOperators(formula: String, expected value: Double) throws {
        #expect(try evaluateFormula(formula) == value)
    }

    // MARK: - Large Number Tests
    @Test(arguments: [
        ("1000000*2", 2000000.0),
        ("10000/100", 100.0),
    ])
    func testLargeNumbers(formula: String, expected value: Double) throws {
        #expect(try evaluateFormula(formula) == value)
    }

    // MARK: - Precision Tests
    @Test(arguments: [
        ("1.0/3.0", 0.3333),
        ("0.1+0.2", 0.3),
    ])
    func testPrecision(formula: String, expected value: Double) throws {
        #expect(try evaluateFormula(formula).roundedToFourDecimalPlaces() == value)
    }

    // MARK: Various formulas use-cases
    @Test(arguments: [
        "4 + 1",
        "  4 + 1  ",
        "4   +   1",
        "10 - 5",
        "5 * 1",
        "40 / 8",
        "1 + 2 * 2",
        "2.5 * 2",
    ])
    func testBasicArithmetic(input: String) async throws {
        let output = try evaluateFormula(input)
        #expect(output == 5)
    }

    @Test(arguments: [
        "(5 + 3) * 2",
        "2 * (5 + (4 - 1))",
        "8 + 4 * 4 / (1 + 1)",
        "((5 + 3) * (5 - 1)) / 2",
        "2.5 * (3 + 4) / 2 - 5 + 12.25",
        "(((((((((1 + 2 + 1)*4))))))))",
    ])
    func testOrderOfOperations(input: String) async throws {
        let result = try evaluateFormula(input)
        #expect(result == 16)
    }

    @Test(arguments: [
        ("-5", -5),
        ("--5", 5),
        ("+5", 5),
        ("2 * -3", -6),
        ("-+3", -3),
    ])
    func testUnaryOperations(input: String, expected: Double) async throws {
        let output = try evaluateFormula(input)
        #expect(output == expected)
    }

    @Test(arguments: [
        ("3.14", 3.14),
        ("0.5", 0.5),
        (".5", 0.5),
        ("5.", 5),
    ])
    func testDecimalHandling(input: String, expected: Double) async throws {
        let output = try evaluateFormula(input)
        #expect(output == expected)
    }

    @Test(arguments: [
        ("1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10", 55),
        ("1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1", 18),  // Long formula
    ])
    func testComplexExpressions(input: String, expected: Double) async throws {
        let output = try evaluateFormula(input)
        #expect(output == expected)
    }

    @Test
    func testDivisionByZeroCase() async throws {
        let expectedError = DimensionValueEvaluationError.divisionByZero
        #expect(throws: expectedError) { _ = try evaluateFormula("5 / 0") }
    }

    @Test
    func testEmptyFormulaCase() async throws {
        let expectedError = DimensionValueEvaluationError.emptyFormula
        #expect(throws: expectedError) { _ = try evaluateFormula("") }
    }

    @Test
    func testInvalidCharacterError_e() async throws {
        let expectedError = DimensionValueEvaluationError.invalidCharacter("e", position: 3)
        #expect(throws: expectedError) { _ = try evaluateFormula("1.5e3 + 2.5") }
    }

    @Test
    func testInvalidCharacterError_comment() async throws {
        let expectedError = DimensionValueEvaluationError.invalidCharacter("c", position: 4)
        #expect(throws: expectedError) { _ = try evaluateFormula("5 + /* comment */ 3") }
    }

    @Test
    func testInvalidCharacterError_missedNumber() async throws {
        let expectedError = DimensionValueEvaluationError.invalidCharacter(" ", position: 2)
        #expect(throws: expectedError) { _ = try evaluateFormula("5 +") }
    }

    @Test(arguments: [
        "5 + *",
        "5 + * 3",
    ])
    func testInvalidCharacterError(input: String) async throws {
        let expectedError = DimensionValueEvaluationError.invalidCharacter("*", position: 2)

        #expect(throws: expectedError) { _ = try evaluateFormula(input) }
    }

    @Test
    func testInvalidSyntax_unexpectedChar() async throws {
        let expectedError = DimensionValueEvaluationError.invalidSyntax("Unexpected character at position 3")
        #expect(throws: expectedError) { _ = try evaluateFormula("5 + 3)") }
    }

    @Test(arguments: [
        "5 × 3)",
        "5 + 3 @",
    ])
    func testInvalidSyntax_unicodeChar(input: String) async throws {
        let expectedError = DimensionValueEvaluationError.invalidSyntax("Invalid characters in formula")

        #expect(throws: expectedError) { _ = try evaluateFormula(input) }
    }

    @Test
    func testInvalidSyntax_multipleDecimal() async throws {
        let expectedError = DimensionValueEvaluationError.invalidSyntax("Multiple decimal points in number")
        #expect(throws: expectedError) { _ = try evaluateFormula("5.5.5") }
    }

    @Test
    func testInvalidSyntax() async throws {
        let expectedError = DimensionValueEvaluationError.invalidSyntax("Unexpected character at position 41")
        #expect(throws: expectedError) { _ = try evaluateFormula("((((((((((((((((((((1)))))))))))))))))))))") }
    }

    @Test
    func testTooLongFormula() async throws {
        var formula = ""
        for _ in 0...250 {
            formula.append("1")
            formula.append("+")
            formula.append("2")
            formula.append("+")
        }
        let expectedError = DimensionValueEvaluationError.invalidSyntax("Formula too long (max 1000 characters)")

        #expect(throws: expectedError) { _ = try evaluateFormula(String(formula.dropLast())) }
    }

    @Test(arguments: [
        "213123424234234126387126498612894712389471239847198471239874908124701927840912840912840192849012840912841028421312342423423412638712649861289471238947123984719847123987490812470192784091284091284019284901284091284102842131234242342341263871264986128947123894712398471984712398749081247019278409128409128401928490128409128410284"
    ])
    func testNumberOutOfRange(input: String) async throws {
        let expectedError = DimensionValueEvaluationError.numberOutOfRange

        #expect(throws: expectedError) { _ = try evaluateFormula(input) }
    }

    @Test
    func testFailingDoubleFromString() throws {
        let parser = ArithmeticalExpressionManager<Double>(formula: "1", doubleFromString: MockDoubleFromString())
        let expectedError = DimensionValueEvaluationError.invalidSyntax("Invalid number format: 1")

        #expect(throws: expectedError) { _ = try parser.evaluate() }
    }

    @Test
    func testRecursionLimitExceeded() async throws {
        let parser = ArithmeticalExpressionManager<Double>(formula: "1", maxRecursionDepth: 0)
        let expectedError = DimensionValueEvaluationError.recursionLimitExceeded

        #expect(throws: expectedError) { _ = try parser.evaluate() }
    }

    private func evaluateFormula(_ formula: String) throws(DimensionValueEvaluationError) -> Double {
        let parser = ArithmeticalExpressionManager<Double>(formula: formula)
        return try parser.evaluate()
    }

    private func evaluateFormula<T: Numeric>(_ formula: String) throws -> T {
        let parser = ArithmeticalExpressionManager<T>(formula: formula)
        return try parser.evaluate()
    }
}
