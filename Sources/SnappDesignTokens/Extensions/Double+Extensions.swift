//
//  Double+Extensions.swift
//
//  Created by Oleksii Kolomiiets on 11.03.2025.
//

import Foundation

extension Double {
    func roundedToFourDecimalPlaces() -> Double {
           return (self * 10_000).rounded() / 10_000
    }
}
