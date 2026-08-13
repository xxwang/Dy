// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Dy",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "Dy", targets: ["Dy"]),
        .library(name: "DyTemplate", targets: ["DyTemplate"]),
        .library(name: "DyComponent", targets: ["DyComponent"]),
        .library(name: "DyCore", targets: ["DyCore"]),
        .library(name: "DyCombineCocoa", targets: ["DyCombineCocoa"]),
        .library(name: "DyLogger", targets: ["DyLogger"]),

    ],
    dependencies: [],
    targets: [
        .target(
            name: "Dy",
            dependencies: [
                .target(name: "DyTemplate"),
                .target(name: "DyComponent"),
                .target(name: "DyCore"),
                .target(name: "DyCombineCocoa"),
                .target(name: "DyLogger"),
            ],
            path: "Sources/Dy",
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
        .target(
            name: "DyTemplate",
            dependencies: [
                .target(name: "DyComponent"),
                .target(name: "DyCore"),
            ],
            path: "Sources/Template",
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
            name: "DyCore",
            path: "Sources/Core",
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
            name: "DyLogger",
            path: "Sources/Logger",
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
    ]
)
