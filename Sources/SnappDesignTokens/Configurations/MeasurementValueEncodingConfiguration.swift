//
//  MeasurementValueEncodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

public enum MeasurementValueEncodingConfiguration: Equatable, Sendable {
    case `default`
    case value(withUnit: Bool = false)
}
