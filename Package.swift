// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Dy",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "Dy",targets: ["Utils", "Extension", "Component", "Template"]),
        .library(name: "Dy.Utils",targets: ["Utils"]),
        .library(name: "Dy.Extension",targets: ["Extension"]),
        .library(name: "Dy.Component",targets: ["Component"]),
        .library(name: "Dy.Template",targets: ["Template"]),
    ],
    targets: [
        .target(
            name: "Utils",
            dependencies: [],
            path: "Sources/Utils",
            swiftSettings: [.define("SPM_MODE"),]
        ),
        .target(
            name: "Extension",
            dependencies: [.target(name: "Utils"),],
            path: "Sources/Extension",
            resources: [.process("Resources"),],
            swiftSettings: [.define("SPM_MODE"),]
        ),
        .target(
            name: "Component",
            dependencies: [
                .target(name: "Extension"),
            ],
            path: "Sources/Component",
            resources: [.process("Resources"),],
            swiftSettings: [.define("SPM_MODE"),]
        ),
        .target(
            name: "Template",
            dependencies: [
                .target(name: "Component"),
            ],
            path: "Sources/Template",
            resources: [.process("Resources"),],
            swiftSettings: [.define("SPM_MODE")]
        ),
    ],
)
