// swift-tools-version: 6.2

import PackageDescription

let package = Package(
        name: "CommonExtensions",
        platforms: [.iOS(.v15), .macOS(.v12)],
        products: [
                .library(name: "CommonExtensions", targets: ["CommonExtensions"])
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
