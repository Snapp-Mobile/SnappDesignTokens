//
//  ArithmeticOperation.swift
//
//  Created by Ilian Konchev on 4.03.25.
//

import Foundation

public enum ArithmeticOperation: String, Decodable, CaseIterable, Equatable, Sendable {
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
    case leftParen = "("
    case rightParen = ")"
}
