// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SingerApp",
    platforms: [
        .iOS(.v18),
        .macOS(.v12)
    ],
    products: [
        .library(name: "SingerApp", targets: ["SingerApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/nalexn/EnvironmentOverrides", from: "0.0.4"),
        .package(url: "https://github.com/nalexn/ViewInspector", from: "0.10.0")
    ],
    targets: [
        .target(
            name: "SingerApp",
            dependencies: [
                .product(name: "EnvironmentOverrides", package: "EnvironmentOverrides")
            ],
            path: "SingerApp",
            exclude: [
                "Resources/Preview Assets.xcassets",
            ],
            resources: [
                .process("Resources/Assets.xcassets"),
                .process("Resources/Localizable.xcstrings"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ],
            linkerSettings: [
                .linkedFramework("UIKit")
            ]
        ),
        .testTarget(
            name: "UnitTests",
            dependencies: [
                "SingerApp",
                .product(name: "ViewInspector", package: "ViewInspector")
            ],
            path: "UnitTests",
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ],
        )
    ]
)
