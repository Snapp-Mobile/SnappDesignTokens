//
//  DimensionConstant.swift
//
//  Created by Volodymyr Voiko on 10.03.2025.
//

import Foundation

/// Represents a constant dimension value with a unit.
///
/// Used within ``DimensionValue`` to represent fixed measurements for width, height,
/// position, spacing, radius, or thickness. This is a ``TokenMeasurement`` specialized
/// for ``DimensionUnit`` (px, rem).
///
/// Example:
/// ```swift
/// // 16 pixels
/// let spacing = DimensionConstant(value: 16, unit: .px)
///
/// // 0.5 rem (50% of default font size)
/// let padding = DimensionConstant(value: 0.5, unit: .rem)
/// ```
public typealias DimensionConstant = TokenMeasurement<DimensionUnit>
