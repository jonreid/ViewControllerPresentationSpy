// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ViewControllerPresentationSpy",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
    ],
    products: [
        .library(
            name: "ViewControllerPresentationSpy",
            targets: ["ViewControllerPresentationSpy"]
        ),
    ],
    targets: [
        .target(
            name: "ViewControllerPresentationSpy",
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
