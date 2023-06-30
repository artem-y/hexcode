// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "hexcode",
    platforms: [
        .macOS(.v12),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
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
            dependencies: ["hexcode"],
            resources: [
                .copy("Resources")
            ]
        ),
    ]
)
