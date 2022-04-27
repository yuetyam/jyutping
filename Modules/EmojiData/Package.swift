// swift-tools-version:5.6

import PackageDescription

let package = Package(
        name: "EmojiData",
        platforms: [.iOS(.v13), .macOS(.v12)],
        products: [
                .library(name: "EmojiData", targets: ["EmojiData"])
        ],
        targets: [
                .target(
                        name: "EmojiData", 
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "EmojiDataTests",
                        dependencies: ["EmojiData"]
                )
        ]
)
