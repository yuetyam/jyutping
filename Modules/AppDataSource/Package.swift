// swift-tools-version: 6.3

import PackageDescription

let package = Package(
        name: "AppDataSource",
        platforms: [.iOS(.v16), .macOS(.v13)],
        products: [
                .library(
                        name: "AppDataSource",
                        targets: ["AppDataSource"]
                )
        ],
        dependencies: [
                .package(path: "../CommonExtensions")
        ],
        targets: [
                .target(
                        name: "AppDataSource",
                        dependencies: [
                                .product(name: "CommonExtensions", package: "CommonExtensions")
                        ],
                        resources: [.process("Resources")]
                )
        ],
        swiftLanguageModes: [.v6]
)
