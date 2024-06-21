// swift-tools-version: 5.10

import PackageDescription

let package = Package(
        name: "Linguistics",
        platforms: [.iOS(.v15), .macOS(.v12)],
        products: [
                .library(
                        name: "Linguistics",
                        targets: ["Linguistics"]
                )
        ],
        targets: [
                .target(
                        name: "Linguistics"
                ),
                .testTarget(
                        name: "LinguisticsTests",
                        dependencies: ["Linguistics"]
                )
        ]
)
