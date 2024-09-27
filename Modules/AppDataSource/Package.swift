// swift-tools-version: 6.0

import PackageDescription

let package = Package(
        name: "AppDataSource",
        platforms: [.iOS(.v15), .macOS(.v12)],
        products: [
                .library(
                        name: "AppDataSource",
                        targets: ["AppDataSource"]
                )
        ],
        targets: [
                .target(
                        name: "AppDataSource",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "AppDataSourceTests",
                        dependencies: ["AppDataSource"]
                )
        ]
)
