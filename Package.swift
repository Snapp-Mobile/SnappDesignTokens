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
    dependencies: [
        .package(url: "https://github.com/Snapp-Mobile/SwiftFormatLintPlugin.git", exact: "1.0.4")
    ],
    targets: [
        .target(
            name: "SnappDesignTokens",
            plugins: [
                .plugin(name: "Lint", package: "SwiftFormatLintPlugin")
            ]
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
