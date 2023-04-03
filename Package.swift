// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "ArgyleMVU-Swift",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "ArgyleMVU",
            targets: ["ArgyleMVU"]
        ),
        .library(
            name: "RemoteData",
            targets: ["RemoteData"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ArgyleMVU",
            dependencies: []
        ),
        .testTarget(
            name: "ArgyleMVUTests",
            dependencies: ["ArgyleMVU"]
        ),
        .target(
            name: "RemoteData",
            dependencies: []
        )
    ]
)
