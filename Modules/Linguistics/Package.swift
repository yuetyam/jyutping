// swift-tools-version: 6.2

import PackageDescription

let package = Package(
        name: "Linguistics",
        platforms: [.iOS(.v16), .macOS(.v13)],
        products: [
                .library(
                        name: "Linguistics",
                        targets: ["Linguistics"]
                )
        ],
        dependencies: [
                .package(path: "../CommonExtensions")
        ],
        targets: [
                .target(
                        name: "Linguistics",
                        dependencies: [
                                .product(name: "CommonExtensions", package: "CommonExtensions")
                        ]
                ),
                .testTarget(
                        name: "LinguisticsTests",
                        dependencies: ["Linguistics"]
                )
        ]
)
