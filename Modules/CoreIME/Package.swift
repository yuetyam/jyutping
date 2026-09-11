// swift-tools-version: 6.4

import PackageDescription

let package = Package(
        name: "CoreIME",
        platforms: [.iOS(.v16), .macOS(.v13)],
        products: [
                .library(
                        name: "CoreIME",
                        targets: ["CoreIME"]
                ),
                .executable(
                        name: "CoreIMEBenchmarks",
                        targets: ["CoreIMEBenchmarks"]
                )
        ],
        dependencies: [
                .package(path: "../CommonExtensions")
        ],
        targets: [
                .target(
                        name: "CoreIME",
                        dependencies: [
                                .product(name: "CommonExtensions", package: "CommonExtensions"),
                                .target(name: "CoreIMEMobileData", condition: .when(platforms: [.iOS])),
                                .target(name: "CoreIMEDesktopData", condition: .when(platforms: [.macOS]))
                        ]
                ),
                .target(
                        name: "CoreIMEMobileData",
                        resources: [.process("Resources")]
                ),
                .target(
                        name: "CoreIMEDesktopData",
                        resources: [.process("Resources")]
                ),
                .testTarget(
                        name: "CoreIMETests",
                        dependencies: ["CoreIME"]
                ),
                .executableTarget(
                        name: "CoreIMEBenchmarks",
                        dependencies: ["CoreIME"]
                )
        ],
        swiftLanguageModes: [.v6]
)
