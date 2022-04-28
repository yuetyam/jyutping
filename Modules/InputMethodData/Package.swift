// swift-tools-version:5.6

import PackageDescription

let package = Package(
        name: "InputMethodData",
        platforms: [.iOS(.v14), .macOS(.v12)],
        products: [
                .library(
                        name: "InputMethodData",
                        targets: ["InputMethodData"]
                )
        ],
        targets: [
                .target(
                        name: "InputMethodData",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "InputMethodDataTests",
                        dependencies: ["InputMethodData"]
                )
        ]
)
