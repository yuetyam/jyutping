// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "KeyboardDataProvider",
        platforms: [.iOS(.v13), .macOS(.v11)],
        products: [
                .library(
                        name: "KeyboardDataProvider",
                        targets: ["KeyboardDataProvider"]
                )
        ],
        targets: [
                .target(
                        name: "KeyboardDataProvider",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "KeyboardDataProviderTests",
                        dependencies: ["KeyboardDataProvider"]
                )
        ]
)
