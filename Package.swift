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
            path: "Sources/Solo"
        ),
        .target(
            name: "SoloTemplate",
            dependencies: [
                .target(name: "SoloComponent"),
                .target(name: "SoloCore"),
            ],
            path: "Sources/Template"
        ),
        .target(
            name: "SoloComponent",
            dependencies: [
                .target(name: "SoloCore"),
            ],
            path: "Sources/Component",
            resources: [
                .process("Resources"),
            ]
        ),
        .target(
            name: "SoloCore",
            path: "Sources/Core"
        ),
        .target(
            name: "SoloCombineCocoa",
            path: "Sources/CombineCocoa"
        ),
        .target(
            name: "SoloLogger",
            path: "Sources/Logger"
        ),
    ]
)
