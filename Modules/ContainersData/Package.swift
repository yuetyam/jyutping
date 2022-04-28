// swift-tools-version:5.6

import PackageDescription

let package = Package(
        name: "ContainersData",
        platforms: [.iOS(.v14), .macOS(.v12)],
        products: [
                .library(
                        name: "ContainersData",
                        targets: ["ContainersData"]
                )
        ],
        targets: [
                .target(
                        name: "ContainersData",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "ContainersDataTests",
                        dependencies: ["ContainersData"]
                )
        ]
)
