// swift-tools-version: 5.10

import PackageDescription

let package = Package(
        name: "Preparing",
        platforms: [.macOS(.v14)],
        products: [.executable(name: "Preparing", targets: ["Preparing"])],
        targets: [
                .executableTarget(
                        name: "Preparing",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "PreparingTests",
                        dependencies: ["Preparing"]
                )
        ]
)
