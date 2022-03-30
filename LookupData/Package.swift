// swift-tools-version:5.6

import PackageDescription

let package = Package(
        name: "LookupData",
        platforms: [.iOS(.v13), .macOS(.v11)],
        products: [
                .library(
                        name: "LookupData",
                        targets: ["LookupData"]
                )
        ],
        targets: [
                .target(
                        name: "LookupData",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "LookupDataTests",
                        dependencies: ["LookupData"]
                )
        ]
)
