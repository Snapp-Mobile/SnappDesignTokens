//
//  CompositeTokenValue+Extensions.swift
//
//  Created by Volodymyr Voiko on 26.03.2025.
//

public enum CompositeTokenValueAliasResolutionError: Error, Equatable {
    case typeMismatch(path: TokenPath)
}

extension CompositeTokenValue {
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
