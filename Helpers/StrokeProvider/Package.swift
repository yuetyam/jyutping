// swift-tools-version:5.5

import PackageDescription

let package = Package(
        name: "StrokeProvider",
        products: [
                .library(
                        name: "StrokeProvider",
                        targets: ["StrokeProvider"]
                )
        ],
        targets: [
                .target(
                        name: "StrokeProvider",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "StrokeProviderTests",
                        dependencies: ["StrokeProvider"]
                )
        ]
)
