// swift-tools-version: 6.2

import PackageDescription

let package = Package(
        name: "AboutKit",
        platforms: [.iOS(.v15), .macOS(.v12)],
        products: [
                .library(name: "AboutKit", targets: ["AboutKit"])
        ],
        targets: [
                .target(
                        name: "AboutKit"
                ),
                .testTarget(
                        name: "AboutKitTests",
                        dependencies: ["AboutKit"]
                )
        ]
)
