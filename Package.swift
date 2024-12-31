// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "hexcode",
    platforms: [
        .macOS(.v13),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/artem-y/swifty-test-assertions.git", from: "0.1.1"),
    ],
    targets: [
        .executableTarget(
            name: "hexcode",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "hexcodeTests",
            dependencies: ["hexcode", .product(name: "SwiftyTestAssertions", package: "swifty-test-assertions")],
            resources: [
                .copy("Resources")
            ]
        ),
    ]
)
