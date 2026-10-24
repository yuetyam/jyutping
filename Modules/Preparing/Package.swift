// swift-tools-version: 6.4

import PackageDescription

let package = Package(
        name: "Preparing",
        platforms: [.macOS(.v27)],
        products: [.executable(name: "Preparing", targets: ["Preparing"])],
        dependencies: [
                .package(path: "../CommonExtensions")
        ],
        targets: [
                .executableTarget(
                        name: "Preparing",
                        dependencies: [
                                .product(name: "CommonExtensions", package: "CommonExtensions")
                        ],
                        resources: [.process("Resources")]
                )
        ],
        swiftLanguageModes: [.v6]
)
