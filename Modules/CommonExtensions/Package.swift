// swift-tools-version: 6.4

import PackageDescription

let package = Package(
        name: "CommonExtensions",
        platforms: [.iOS(.v17), .macOS(.v14)],
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
        ],
        swiftLanguageModes: [.v6]
)
