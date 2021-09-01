// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SkipTools-Legacy",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SkipTools-Legacy",
            targets: ["SkipTools"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .binaryTarget(
            name: "SkipTools",
            url: "https://github.com/GoSkip/SkipTools-Legacy-Source/releases/download/4.2.0/SkipTools-4.2.0.xcframework.zip",
            checksum: "559d40b8ba379ba29159cf326d69e7c432664ac48031ee9148c6a0f38fdaab0a")
    ]
)
