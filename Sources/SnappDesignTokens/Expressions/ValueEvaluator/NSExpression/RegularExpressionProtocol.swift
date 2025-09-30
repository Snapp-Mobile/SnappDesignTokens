//
//  RegularExpressionProtocol.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

protocol RegularExpressionProtocol: Sendable {
    func expression(pattern: String) throws -> NSRegularExpression
}

struct RegularExpression: RegularExpressionProtocol {
    func expression(pattern: String) throws -> NSRegularExpression {
        try NSRegularExpression(pattern: pattern)
    }
}
