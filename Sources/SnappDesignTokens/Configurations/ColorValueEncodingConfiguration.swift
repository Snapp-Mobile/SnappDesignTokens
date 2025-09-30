//
//  ColorValueEncodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

public enum ColorValueEncodingConfiguration: Equatable, Sendable {
    /// Design Token Color format:
    /// https://tr.designtokens.org/color/#format
    case `default`
    /// 8 digits HEX using RGB Hexadecimal Notations:
    /// https://www.w3.org/TR/css-color-4/#hex-notation
    case hex
}
