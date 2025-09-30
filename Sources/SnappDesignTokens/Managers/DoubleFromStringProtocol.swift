//
//  DoubleFromStringProtocol.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

protocol DoubleFromStringProtocol {
    func double(_ string: String) -> Double?
}

struct DoubleFromString: DoubleFromStringProtocol {
    func double(_ string: String) -> Double? {
        Double(string)
    }
}
