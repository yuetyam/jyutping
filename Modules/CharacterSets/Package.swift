// swift-tools-version: 5.7

import PackageDescription

let package = Package(
        name: "CharacterSets",
        platforms: [.iOS(.v14), .macOS(.v12)],
        products: [
                .library(name: "CharacterSets", targets: ["CharacterSets"])
        ],
        targets: [
                .target(
                        name: "CharacterSets",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "CharacterSetsTests",
                        dependencies: ["CharacterSets"]
                )
        ]
)
