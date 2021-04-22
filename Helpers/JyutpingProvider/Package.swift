// swift-tools-version:5.4

import PackageDescription

let package = Package(
        name: "JyutpingProvider",
        platforms: [.iOS(.v13), .macOS(.v11)],
        products: [
                .library(
                        name: "JyutpingProvider",
                        targets: ["JyutpingProvider"]
                ),
        ],
        targets: [
                .target(
                        name: "JyutpingProvider",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "JyutpingProviderTests",
                        dependencies: ["JyutpingProvider"]
                ),
        ]
)
