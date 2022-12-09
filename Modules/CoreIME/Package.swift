// swift-tools-version: 5.7

import PackageDescription

let package = Package(
        name: "CoreIME",
        platforms: [.iOS(.v14), .macOS(.v12)],
        products: [
                .library(
                        name: "CoreIME",
                        targets: ["CoreIME"]
                )
        ],
        targets: [
                .target(
                        name: "CoreIME",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "CoreIMETests",
                        dependencies: ["CoreIME"]
                )
        ]
)
