// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Dy",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "Dy", targets: ["Dy"]),
        .library(name: "DyLogger", targets: ["DyLogger"]),
        .library(name: "DyComponent", targets: ["DyComponent"]),
        .library(name: "DyTemplate", targets: ["DyTemplate"]),
    ],
    targets: [
        .target(
            name: "DyLogger",
            path: "Sources/Logger",
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
        .target(
            name: "DyComponent",
            dependencies: [
                .target(name: "Dy"),
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
                .target(name: "Dy"),
                .target(name: "DyComponent"),
                .target(name: "DyLogger"),
            ],
            path: "Sources/Template",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
    ]
)
