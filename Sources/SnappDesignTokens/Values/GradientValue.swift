//
//  GradientValue.swift
//
//  Created by Volodymyr Voiko on 03.04.2025.
//

import Foundation

/// Represents a color gradient with multiple color stops.
///
/// DTCG composite token defining color transitions across an axis using an array of
/// ``GradientColor`` stops. Each stop specifies a color and position (0-1 range).
///
/// Example:
/// ```swift
/// // Simple blue-to-red gradient
/// let gradient: GradientValue = [
///     GradientColor(color: .value(.blue), position: .value(0)),
///     GradientColor(color: .value(.red), position: .value(1))
/// ]
///
/// // Multi-stop gradient with alias
/// let complex: GradientValue = [
///     GradientColor(color: .value(.black), position: .value(0)),
///     GradientColor(color: .alias(TokenPath("brand-primary")), position: .value(0.5)),
///     GradientColor(color: .value(.black), position: .value(1))
/// ]
/// ```
public typealias GradientValue = [GradientColor]
