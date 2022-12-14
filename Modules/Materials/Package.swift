// swift-tools-version: 5.7

import PackageDescription

let package = Package(
        name: "Materials",
        platforms: [.iOS(.v14), .macOS(.v12)],
        products: [
                .library(
                        name: "Materials",
                        targets: ["Materials"]
                )
        ],
        targets: [
                .target(
                        name: "Materials",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "MaterialsTests",
                        dependencies: ["Materials"]
                )
        ]
)
