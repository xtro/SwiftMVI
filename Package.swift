// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SwiftMVI",
    platforms: [
        .macOS("10.15"),
        .iOS("13.0"),
        .tvOS("13.0"),
        .watchOS("6.0"),
    ],
    products: [
        .library(name: "SwiftMVI", targets: ["SwiftMVI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/xtro/SwiftUseCase.git", from: "0.0.1"),
        .package(url: "https://github.com/pointfreeco/swift-case-paths.git", from: "0.4.0"),
    ],
    targets: [
        .target(
            name: "SwiftMVI",
            dependencies: [
                .product(name: "SwiftUseCase", package: "SwiftUseCase"),
                .product(name: "CasePaths", package: "swift-case-paths"),
            ],
            path: "Sources"
        ),
        .testTarget(name: "SwiftMVITests", dependencies: ["SwiftMVI"], path: "Tests"),
    ]
)
