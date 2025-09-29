//
//  DynamicCodingKey.swift
//
//  Created by Oleksii Kolomiiets on 04.03.2025.
//

import Foundation

struct DynamicCodingKey: CodingKey, Equatable {
    var stringValue: String
    var intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
