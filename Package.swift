// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Solo",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "Solo", targets: ["Solo"]),
        .library(name: "SoloTemplate", targets: ["SoloTemplate"]),
        .library(name: "SoloComponent", targets: ["SoloComponent"]),
        .library(name: "SoloCore", targets: ["SoloCore"]),
        .library(name: "SoloCombineCocoa", targets: ["SoloCombineCocoa"]),
        .library(name: "SoloLogger", targets: ["SoloLogger"]),

    ],
    dependencies: [],
    targets: [
        .target(
            name: "Solo",
            dependencies: [
                .target(name: "SoloTemplate"),
                .target(name: "SoloComponent"),
                .target(name: "SoloCore"),
                .target(name: "SoloCombineCocoa"),
                .target(name: "SoloLogger"),
            ],
            path: "Sources/Solo",
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
        .target(
            name: "SoloTemplate",
            dependencies: [
                .target(name: "SoloComponent"),
                .target(name: "SoloCore"),
            ],
            path: "Sources/Template",
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
        .target(
            name: "SoloComponent",
            dependencies: [
                .target(name: "SoloCore"),
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
            name: "SoloCore",
            path: "Sources/Core",
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
        .target(
            name: "SoloCombineCocoa",
            path: "Sources/CombineCocoa",
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
        .target(
            name: "SoloLogger",
            path: "Sources/Logger",
            swiftSettings: [
                .define("SPM_MODE"),
            ]
        ),
    ]
)
