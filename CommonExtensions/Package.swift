// swift-tools-version: 5.5

import PackageDescription

let package = Package(
        name: "CommonExtensions",
        platforms: [.iOS(.v13), .macOS(.v11)],
        products: [
                .library(
                        name: "CommonExtensions",
                        targets: ["CommonExtensions"]
                )
        ],
        targets: [
                .target(
                        name: "CommonExtensions"
                ),
                .testTarget(
                        name: "CommonExtensionsTests",
                        dependencies: ["CommonExtensions"]
                )
        ]
)
