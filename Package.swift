// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Dy",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "DyUtils", targets: ["DyUtils"]),
        .library(name: "DyExtension", targets: ["DyExtension"]),
        .library(name: "DyComponent", targets: ["DyComponent"]),
        .library(name: "DyTemplate", targets: ["DyTemplate"]),
        .library(name: "Dy", targets: ["DyUtils", "DyExtension", "DyComponent", "DyTemplate"]),
    ],
    targets: [
        .target(
            name: "DyUtils",
            dependencies: [],
            path: "Sources/Utils",
            swiftSettings: [.define("SPM_MODE")]
        ),
        .target(
            name: "DyExtension",
            dependencies: [.target(name: "DyUtils")],
            path: "Sources/Extension",
            resources: [.process("Resources")],
            swiftSettings: [.define("SPM_MODE")]
        ),
        .target(
            name: "DyComponent",
            dependencies: [.target(name: "DyExtension")],
            path: "Sources/Component",
            resources: [.process("Resources")],
            swiftSettings: [.define("SPM_MODE")]
        ),
        .target(
            name: "DyTemplate",
            dependencies: [
                .target(name: "DyComponent"),
            ],
            path: "Sources/Template",
            resources: [.process("Resources")],
            swiftSettings: [.define("SPM_MODE")]
        ),
    ]
)
