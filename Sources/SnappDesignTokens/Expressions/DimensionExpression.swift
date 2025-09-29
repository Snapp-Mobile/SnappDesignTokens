//
//  DimensionExpression.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

public struct DimensionExpression: Equatable, Sendable {
    private enum Constant {
        static let defaultRemBaseValue: CGFloat = 16
    }

    public var elements: [DimensionExpressionElement]

    public init(elements: [DimensionExpressionElement]) {
        self.elements = elements
    }    
}

extension DimensionExpression: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawString = try container.decode(String.self)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            self.elements = try rawString.split()
        } catch let error as DimensionExpressionParsingError {
            throw error
        } catch {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription:
                        "Failed to parse expression element from string: \"\(rawString)\"",
                    underlyingError: error
                )
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        let stringValue = elements.map(\.rawValue).joined()
        try container.encode(stringValue)
    }
}

extension String {
    fileprivate func split(by operations: [ArithmeticOperation] = ArithmeticOperation.allCases) throws
        -> [DimensionExpressionElement]
    {
        let separators = CharacterSet(charactersIn: operations.map(\.rawValue).joined())
        let substrings = splitWithSeparators(separators: separators)

        guard substrings.count > 0 else {
            throw DimensionExpressionParsingError.invalidFormat
        }

        return try substrings.reduce(into: []) { partialResult, element in
            if let operation = ArithmeticOperation(rawValue: element) {
                partialResult.append(.operation(operation))
            } else if let path = TokenPath(rawValue: element) {
                partialResult.append(.alias(path))
            } else if let constant = try? DimensionConstant(stringValue: element) {
                partialResult.append(.value(constant))
            } else {
                throw DimensionExpressionParsingError.invalidElement(element)
            }
        }
    }

    func splitWithSeparators(separators: CharacterSet) -> [String] {
        var result: [String] = []
        var currentComponent = ""

        for character in self {
            if separators.contains(character.unicodeScalars.first!) {
                // If we have accumulated non-separator characters, add them first
                if !currentComponent.isEmpty {
                    result.append(currentComponent)
                    currentComponent = ""
                }
                // Add the separator as its own element
                result.append(String(character))
            } else {
                currentComponent.append(character)
            }
        }

        if !currentComponent.isEmpty {
            result.append(currentComponent)
        }

        return result
    }
}
