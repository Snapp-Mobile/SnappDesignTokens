//
//  UnitType.swift
//
//  Created by Volodymyr Voiko on 31.03.2025.
//

import Foundation

public protocol UnitType:
    Codable,
    Equatable,
    Sendable,
    RawRepresentable
where RawValue == String {
    static func decode(_ decoder: any Decoder) throws -> TokenMeasurement<Self>?
}

extension UnitType {
    public static func decode(_: any Decoder) throws -> TokenMeasurement<Self>? { nil }
}
