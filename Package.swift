// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Dy",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "DyCore", targets: ["DyCore"]),
        .library(name: "DyComponent", targets: ["DyComponent"]),
        .library(name: "DyTemplate", targets: ["DyTemplate"]),
        .library(name: "DyCombineCocoa", targets: ["DyCombineCocoa"]),
        .library(name: "DyNetwork", targets: ["DyNetwork"]),
        .library(name: "DyLogger", targets: ["DyLogger"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.0")),
    ],
    targets: [
        .target(
            name: "DyCore",
            path: "Sources/Core",
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
        .target(
            name: "DyComponent",
            dependencies: [
                .target(name: "DyCore"),
            ],
            path: "Sources/Component",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
        .target(
            name: "DyTemplate",
            dependencies: [
                .target(name: "DyCore"),
                .target(name: "DyComponent"),
            ],
            path: "Sources/Template",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
        .target(
            name: "DyCombineCocoa",
            path: "Sources/CombineCocoa",
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
        .target(
            name: "DyNetwork",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
            ],
            path: "Sources/Network",
            exclude: ["README.md"],
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
        .target(
            name: "DyLogger",
            path: "Sources/Logger",
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
    ]
)
