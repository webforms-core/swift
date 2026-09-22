// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "WebFormsCore",
    products: [
        .library(
            name: "WebFormsCore",
            targets: ["WebFormsCore"]
        )
    ],
    targets: [
        .target(
            name: "WebFormsCore"
        ),
        .testTarget(
            name: "WebFormsCoreTests",
            dependencies: ["WebFormsCore"]
        )
    ]
)