// swift-tools-version: 5.6

import PackageDescription

let package = Package(
        name: "CharacterSets",
        platforms: [.iOS(.v13), .macOS(.v12)],
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
