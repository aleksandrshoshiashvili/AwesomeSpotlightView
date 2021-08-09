// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "AwesomeSpotlightView",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "AwesomeSpotlightView",
            targets: ["AwesomeSpotlightView"]),
    ],
    targets: [
        .target(
            name: "AwesomeSpotlightView",
            dependencies: [],
            path: "AwesomeSpotlightView/Classes/"),
    ]
)