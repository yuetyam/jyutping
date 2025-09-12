// swift-tools-version: 6.2

import PackageDescription

let package = Package(
        name: "Preparing",
        platforms: [.macOS(.v26)],
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
