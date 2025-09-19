// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SnappDesignTokens",
    products: [
        .library(
            name: "SnappDesignTokens",
            targets: ["SnappDesignTokens"]
        ),
    ],
    targets: [
        .target(
            name: "SnappDesignTokens"
        ),
        .testTarget(
            name: "SnappDesignTokensTests",
            dependencies: ["SnappDesignTokens"]
        ),
    ]
)
