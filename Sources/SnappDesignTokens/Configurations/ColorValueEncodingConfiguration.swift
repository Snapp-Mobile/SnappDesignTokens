//
//  ColorValueEncodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

/// Configuration for color value encoding format.
public enum ColorValueEncodingConfiguration: Equatable, Sendable {
    /// DTCG color format with explicit color space and components.
    ///
    /// Per DTCG specification: https://tr.designtokens.org/color/#format
    case `default`

    /// 8-digit hex format using RGB hexadecimal notation.
    ///
    /// Per CSS Color Module Level 4: https://www.w3.org/TR/css-color-4/#hex-notation
    case hex
}
