// swift-tools-version: 6.4

import PackageDescription

let package = Package(
        name: "AboutKit",
        platforms: [.iOS(.v17), .macOS(.v14)],
        products: [
                .library(name: "AboutKit", targets: ["AboutKit"])
        ],
        targets: [
                .target(
                        name: "AboutKit"
                )
        ],
        swiftLanguageModes: [.v6]
)
