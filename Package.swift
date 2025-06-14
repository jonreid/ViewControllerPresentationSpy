// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "ViewControllerPresentationSpy",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .library(
            name: "ViewControllerPresentationSpy",
            targets: ["ViewControllerPresentationSpy"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/jonreid/FailKit.git", branch: "main")
    ],
    targets: [
        .target(
            name: "ViewControllerPresentationSpy",
            dependencies: ["FailKit"],
            path: "Source",
            exclude: [
                "MakeDistribution.sh",
                "makeXCFramework.sh",
                "Info.plist",
                "XcodeWarnings.xcconfig",
            ]
        ),
    ]
)
