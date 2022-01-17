// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "Simplifier",
        platforms: [.iOS(.v13), .macOS(.v12)],
        products: [
                .library(name: "Simplifier", targets: ["Simplifier"])
        ],
        targets: [
                .target(
                        name: "Simplifier", resources: [.process("Resources")]),
                .testTarget(name: "SimplifierTests", dependencies: ["Simplifier"])
        ]
)
