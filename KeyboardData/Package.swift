// swift-tools-version:5.5

import PackageDescription

let package = Package(
        name: "KeyboardData",
        platforms: [.iOS(.v13), .macOS(.v11)],
        products: [
                .library(
                        name: "KeyboardData",
                        targets: ["KeyboardData"]
                )
        ],
        targets: [
                .target(
                        name: "KeyboardData",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "KeyboardDataTests",
                        dependencies: ["KeyboardData"]
                )
        ]
)
