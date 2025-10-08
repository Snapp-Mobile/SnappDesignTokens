//
//  CompositeTokenValue+Extensions.swift
//
//  Created by Volodymyr Voiko on 26.03.2025.
//

/// Error thrown when resolving a composite token value alias.
public enum CompositeTokenValueAliasResolutionError: Error, Equatable {
    /// Referenced token type does not match expected type.
    ///
    /// ### Example
    /// ```swift
    /// // fontSize references a color instead of a dimension
    /// fontSize: .alias(TokenPath("dimension", "fontSize"))  // where dimension.fontSize is a color
    /// ```
    case typeMismatch(path: TokenPath)
}

extension CompositeTokenValue {
    /// Resolves alias reference to actual value.
    ///
    /// Returns the value unchanged if it's already a direct value. For aliases, looks up
    /// the referenced token and extracts its value.
    ///
    /// ### Example
    /// ```swift
    /// let fontSize: CompositeTokenValue<DimensionValue> = .alias(TokenPath("dimension", "fontSize"))
    /// let resolved = try fontSize.resolvingAliases(root: token)  // Returns .value(16px)
    /// ```
    ///
    /// - Parameter root: Root token containing the complete token tree for lookups
    /// - Returns: Resolved composite token value with direct value
    /// - Throws: ``TokenResolutionError`` if alias path is invalid, ``CompositeTokenValueAliasResolutionError/typeMismatch(path:)`` if referenced token type does not match expected type
    public func resolvingAliases(root: Token) throws -> Self {
        guard case .alias(let path) = self else {
            return self
        }
        let resolved = try root.resolveAlias(path)
        guard
            case .value(let value) = resolved,
            let extractedValue = value.anyValue as? Value
        else {
            throw CompositeTokenValueAliasResolutionError.typeMismatch(path: path)
        }
        return .value(extractedValue)
    }
}
