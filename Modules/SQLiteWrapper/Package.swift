// swift-tools-version: 6.4

import PackageDescription

let package = Package(
        name: "SQLiteWrapper",
        platforms: [.iOS(.v17), .macOS(.v14)],
        products: [
                .library(name: "SQLiteWrapper", targets: ["SQLiteWrapper"])
        ],
        targets: [
                .target(
                        name: "SQLiteWrapper",
                        swiftSettings: [
                                .enableUpcomingFeature("ApproachableConcurrency")
                        ]
                ),
                .testTarget(
                        name: "SQLiteWrapperTests",
                        dependencies: ["SQLiteWrapper"],
                        swiftSettings: [
                                .enableUpcomingFeature("ApproachableConcurrency")
                        ]
                )
        ],
        swiftLanguageModes: [.v6]
)
