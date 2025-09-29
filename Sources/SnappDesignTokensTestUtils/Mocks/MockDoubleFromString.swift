//
//  MockDoubleFromString.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

@testable import SnappDesignTokens

struct MockDoubleFromString: DoubleFromStringProtocol {
    func double(_ string: String) -> Double? { nil }
}
