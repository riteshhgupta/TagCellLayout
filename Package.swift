// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TagCellLayout",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "TagCellLayout", targets: ["TagCellLayout"])
    ],
    targets: [
        .target(
            name: "TagCellLayout",
            path: "Source"
        )
    ]
)
