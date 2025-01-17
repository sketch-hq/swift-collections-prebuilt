// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCollectionsPrebuilt",
    platforms: [
        .iOS(.v17), .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Collections",
            targets: ["Collections"]),
    ],
    targets: [
        .binaryTarget(
            name: "Collections",
            path: "./xcframework/swift-collections.xcframework.zip"
        )
    ]
)
