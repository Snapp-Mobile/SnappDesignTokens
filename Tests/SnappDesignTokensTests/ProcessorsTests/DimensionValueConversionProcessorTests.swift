//
//  DimensionValueConversionProcessorTests.swift
//
//  Created by Volodymyr Voiko on 13.03.2025.
//

import Testing

@testable import SnappDesignTokens
@testable import SnappDesignTokensTestUtils

@Suite
struct DimensionValueConversionProcessorTests {
    @Test(
        arguments: [
            (
                .group([
                    "base": .group([
                        "title1": .value(
                            .typography(
                                TypographyValue(
                                    fontFamily: .value("SFPro"),
                                    fontSize: .value(.constant(.init(value: 10, unit: .rem))),
                                    fontWeight: .value(.bold),
                                    letterSpacing: .value(.constant(.init(value: 12, unit: .px))),
                                    lineHeight: .value(12)))),
                        "dimension1": .value(
                            .dimension(.constant(.init(value: 10, unit: .px)))),
                        "dimension2": .value(
                            .dimension(.constant(.init(value: 10, unit: .rem)))),
                        "dimension3": .value(
                            .dimension(
                                .expression(
                                    .value(.init(value: 10, unit: .px)),
                                    .operation(.add),
                                    .value(.init(value: 10, unit: .rem))
                                ))),
                    ])
                ]),
                .px,
                .group([
                    "base": .group([
                        "title1": .value(.typography(
                            TypographyValue(
                                fontFamily: .value("SFPro"),
                                fontSize: .value(.constant(.init(value: 160, unit: .px))),
                                fontWeight: .value(.bold),
                                letterSpacing: .value(.constant(.init(value: 12, unit: .px))),
                                lineHeight: .value(12)))),
                        "dimension1": .value(
                            .dimension(.constant(.init(value: 10, unit: .px)))),
                        "dimension2": .value(
                            .dimension(.constant(.init(value: 160, unit: .px)))),
                        "dimension3": .value(
                            .dimension(
                                .expression(
                                    .value(.init(value: 10, unit: .px)),
                                    .operation(.add),
                                    .value(.init(value: 160, unit: .px))
                                ))),
                    ])
                ])
            ),
            (
                .group([
                    "base": .group([
                        "dimension1": .value(
                            .dimension(.constant(.init(value: 160, unit: .px)))),
                        "dimension2": .value(
                            .dimension(.constant(.init(value: 1, unit: .rem)))),
                        "dimension3": .value(
                            .dimension(
                                .expression(
                                    .value(.init(value: 160, unit: .px)),
                                    .operation(.add),
                                    .value(.init(value: 1, unit: .rem))
                                ))),
                    ])
                ]),
                .rem,
                .group([
                    "base": .group([
                        "dimension1": .value(
                            .dimension(.constant(.init(value: 10, unit: .rem)))),
                        "dimension2": .value(
                            .dimension(.constant(.init(value: 1, unit: .rem)))),
                        "dimension3": .value(
                            .dimension(
                                .expression(
                                    .value(.init(value: 10, unit: .rem)),
                                    .operation(.add),
                                    .value(.init(value: 1, unit: .rem))
                                ))),
                    ])
                ])
            ),
            (
                .group(["base": .group(["color": .value(.color(.red))])]),
                .px,
                .group(["base": .group(["color": .value(.color(.red))])])
            ),
        ] as [(
            Token,
            DimensionUnit,
            Token
        )]
    )
    func testConversion(
        token: Token,
        targetUnit: DimensionUnit,
        expectedToken: Token
    ) async throws {
        let processor: DimensionValueConversionProcessor = .dimensionValueConversion(
            using: .converter(with: 16),
            targetUnit: targetUnit
        )

        let convertedToken = try await processor.process(token)
        #expect(convertedToken == expectedToken)
    }
}
