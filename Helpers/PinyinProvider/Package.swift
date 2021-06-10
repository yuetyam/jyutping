// swift-tools-version:5.4

import PackageDescription

let package = Package(
        name: "PinyinProvider",
        products: [
                .library(
                        name: "PinyinProvider",
                        targets: ["PinyinProvider"]
                )
        ],
        targets: [
                .target(
                        name: "PinyinProvider",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "PinyinProviderTests",
                        dependencies: ["PinyinProvider"]
                )
        ]
)
