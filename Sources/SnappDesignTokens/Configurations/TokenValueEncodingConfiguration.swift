//
//  TokenValueEncodingConfiguration.swift
//
//  Created by Oleksii Kolomiiets on 9/23/25.
//

import Foundation

public struct TokenValueEncodingConfiguration: Equatable, Sendable {
    public static let `default` = Self()

    public let colorEncodingConfiguration: ColorValueEncodingConfiguration?
    public let fileEncodingConfiguration: FileValueEncodingConfiguration?
    public let measurementEncodingConfiguration: MeasurementValueEncodingConfiguration?

    public init(
        color colorEncodingConfiguration: ColorValueEncodingConfiguration? =
            nil,
        file fileEncodingConfiguration: FileValueEncodingConfiguration? = nil,
        measurement measurementEncodingConfiguration: MeasurementValueEncodingConfiguration? = nil
    ) {
        self.colorEncodingConfiguration = colorEncodingConfiguration
        self.fileEncodingConfiguration = fileEncodingConfiguration
        self.measurementEncodingConfiguration = measurementEncodingConfiguration
    }
}
