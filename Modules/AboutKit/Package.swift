// swift-tools-version: 5.9

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
