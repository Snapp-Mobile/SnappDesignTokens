//
//  TokenValue+Extensions.swift
//
//  Created by Volodymyr Voiko on 09.04.2025.
//

import Foundation

extension TokenValue {
    /// Type-erased value for the token.
    ///
    /// Returns the underlying value as `Any`, useful for generic operations and type casting.
    public var anyValue: Any {
        switch self {
        case .color(let value):
            return value
        case .dimension(let value):
            return value
        case .file(let value):
            return value
        case .fontFamily(let value):
            return value
        case .fontWeight(let value):
            return value
        case .number(let value):
            return value
        case .typography(let value):
            return value
        case .gradient(let value):
            return value
        case .duration(let value):
            return value
        case .shadow(let shadow):
            return shadow
        case .strokeStyle(let strokeStyle):
            return strokeStyle
        case .border(let border):
            return border
        case .cubicBezier(let cubicBezier):
            return cubicBezier
        case .transition(let transition):
            return transition
        }
    }
}
