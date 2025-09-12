// swift-tools-version: 6.2

import PackageDescription

let package = Package(
        name: "CoreIME",
        platforms: [.iOS(.v15), .macOS(.v12)],
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
