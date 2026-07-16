// swift-tools-version: 6.3

import PackageDescription

let package = Package(
        name: "AboutKit",
        platforms: [.iOS(.v16), .macOS(.v13)],
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
