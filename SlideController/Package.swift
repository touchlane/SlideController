// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SlideController",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SlideController",
            targets: ["SlideController"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SlideController",
            dependencies: [],
            path: "Sources",
            exclude: ["SlideController/SupportingFiles/Info.plist"]
        ),
        .testTarget(
            name: "SlideControllerTests",
            dependencies: ["SlideController"],
            path: "Tests",
            exclude: ["SlideControllerTests/SupportingFiles/Info.plist"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
