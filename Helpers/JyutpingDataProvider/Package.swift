// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "JyutpingDataProvider",
        platforms: [.iOS(.v13), .macOS(.v11)],
        products: [
                .library(
                        name: "JyutpingDataProvider",
                        targets: ["JyutpingDataProvider"]
                )
        ],
        targets: [
                .target(
                        name: "JyutpingDataProvider",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "JyutpingDataProviderTests",
                        dependencies: ["JyutpingDataProvider"]
                )
        ]
)
