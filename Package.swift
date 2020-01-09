// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "SwiftUIComponents",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SwiftUIComponents",
            targets: ["SwiftUIComponents"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/cfergie/foundation-utils.git", from: "0.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftUIComponents",
            dependencies: ["FoundationUtils"]),
    ]
)
