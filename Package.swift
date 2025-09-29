// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SnappDesignTokens",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
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
        .target(name: "SnappDesignTokensTestUtils", dependencies: ["SnappDesignTokens"]),
        .testTarget(
            name: "SnappDesignTokensTests",
            dependencies: ["SnappDesignTokens", "SnappDesignTokensTestUtils"],
            resources: [
                .copy("Resources/alien.svg"),
            ]
        ),
    ]
)
