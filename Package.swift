// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "ViewControllerPresentationSpy",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
    ],
    products: [
        .library(
            name: "ViewControllerPresentationSpy",
            targets: ["ViewControllerPresentationSpy"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/jonreid/FailKit.git", branch: "1.0.0")
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
