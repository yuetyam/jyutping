// swift-tools-version: 6.2

import PackageDescription

let package = Package(
        name: "CommonExtensions",
        platforms: [.iOS(.v16), .macOS(.v13)],
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
