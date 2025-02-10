// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Nonempty",
    products: [
        .library(
            name: "Nonempty",
            targets: ["Nonempty"]),
    ],
    targets: [
        .target(
            name: "Nonempty"),
        .testTarget(
            name: "NonemptyTests",
            dependencies: ["Nonempty"])
    ]
)
