// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "EmojiData",
        platforms: [.iOS(.v13), .macOS(.v11)],
        products: [
                .library(name: "EmojiData", targets: ["EmojiData"])
        ],
        targets: [
                .target(name: "EmojiData", resources: [.process("Resources")]),
                .testTarget(name: "EmojiDataTests", dependencies: ["EmojiData"])
        ]
)
