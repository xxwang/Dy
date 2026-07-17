// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Dy",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "DyCommon", targets: ["DyCommon"]),
        .library(name: "DyExtension", targets: ["DyExtension"]),
        .library(name: "DyComponent", targets: ["DyComponent"]),
        .library(name: "DyTemplate", targets: ["DyTemplate"]),
        .library(name: "Dy", targets: ["DyCommon", "DyExtension", "DyComponent", "DyTemplate"]),
    ],
    targets: [
        .target(
            name: "DyCommon",
            dependencies: [],
            path: "Sources/Common",
            swiftSettings: [.define("SPM_MODE")]
        ),
        .target(
            name: "DyExtension",
            dependencies: [.target(name: "DyCommon")],
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
