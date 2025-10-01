//
//  DimensionValueConverter.swift
//
//  Created by Volodymyr Voiko on 13.03.2025.
//

/// Protocol for converting dimension values between units.
///
/// Defines conversion strategy for translating dimension constants from one
/// unit to another. Implementations determine conversion ratios and base values.
///
/// Default implementation: ``DefaultDimensionValueConverter``
///
/// Example:
/// ```swift
/// struct CustomConverter: DimensionValueConverter {
///     func convert(_ constant: DimensionConstant, to targetUnit: DimensionUnit) -> DimensionConstant {
///         // Custom conversion logic
///     }
/// }
/// ```
public protocol DimensionValueConverter: Sendable {
    /// Converts dimension constant to target unit.
    ///
    /// - Parameters:
    ///   - constant: Source dimension constant
    ///   - targetUnit: Target dimension unit
    /// - Returns: Converted dimension constant in target unit
    func convert(
        _ constant: DimensionConstant,
        to targetUnit: DimensionUnit
    ) -> DimensionConstant
}

extension DimensionValueConverter {
    /// Converts composite token dimension value to target unit.
    ///
    /// Convenience method for converting dimension values wrapped in
    /// ``CompositeTokenValue``. Only converts constant dimension values;
    /// aliases and expressions pass through unchanged.
    ///
    /// - Parameters:
    ///   - value: Composite token value wrapping dimension
    ///   - targetUnit: Target dimension unit
    /// - Returns: Converted composite token value or original if not a constant
    public func convert(
        _ value: CompositeTokenValue<DimensionValue>,
        to targetUnit: DimensionUnit
    ) -> CompositeTokenValue<DimensionValue> {
        guard case .value(.constant(let constant)) = value else {
            return value
        }

        return .value(.constant(convert(constant, to: targetUnit)))
    }
}
