// swift-tools-version: 5.7

import PackageDescription

let package = Package(
        name: "Prepare",
        platforms: [.macOS(.v13)],
        products: [.executable(name: "prepare", targets: ["Prepare"])],
        targets: [
                .executableTarget(
                        name: "Prepare",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "PrepareTests",
                        dependencies: ["Prepare"]
                )
        ]
)
