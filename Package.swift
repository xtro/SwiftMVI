// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SwiftMVI",
    platforms: [
        .macOS("10.15"),
        .iOS("13.0"),
        .tvOS("13.0"),
        .watchOS("6.0")
    ],
    products: [
        .library(name: "SwiftMVI", targets: ["SwiftMVI"]),
    ],
    targets: [
        .target(
            name: "SwiftMVI",
            path: "Sources"
        ),
        .testTarget(name: "SwiftMVITests", dependencies: ["SwiftMVI"], path: "Tests"),
    ]
)
