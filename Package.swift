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
            url: "https://github.com/GoSkip/SkipTools-Legacy-Source/releases/download/4.3.2/SkipTools.xcframework.zip",
            checksum: "31d96ad5e4f283a558a7f6d53de4045ec924fd3cb804056470e0e084fe1e8018")
    ]
)
