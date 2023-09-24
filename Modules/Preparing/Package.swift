// swift-tools-version: 5.9

import PackageDescription

let package = Package(
        name: "Preparing",
        platforms: [.macOS(.v13)],
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
