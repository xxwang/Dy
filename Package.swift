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
            path: "Sources/Dy"
        ),
        .target(
            name: "DyTemplate",
            dependencies: [
                .target(name: "DyComponent"),
                .target(name: "DyCore"),
            ],
            path: "Sources/Template"
        ),
        .target(
            name: "DyComponent",
            dependencies: [
                .target(name: "DyCore"),
            ],
            path: "Sources/Component",
            resources: [
                .process("Resources"),
            ]
        ),
        .target(
            name: "DyCore",
            path: "Sources/Core"
        ),
        .target(
            name: "DyCombineCocoa",
            path: "Sources/CombineCocoa"
        ),
        .target(
            name: "DyLogger",
            path: "Sources/Logger"
        ),
    ]
)
