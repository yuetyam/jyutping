// swift-tools-version: 6.4

import PackageDescription

let package = Package(
        name: "Linguistics",
        platforms: [.iOS(.v17), .macOS(.v14)],
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
                )
        ],
        swiftLanguageModes: [.v6]
)
