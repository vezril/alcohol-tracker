// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "AlcoholTracker",
    // Minimums chosen so the package is consumable by the iOS 26 app while
    // remaining testable on the macOS toolchain via `swift test` (no Xcode needed).
    platforms: [
        .iOS(.v17),
        .macOS(.v13),
    ],
    products: [
        .library(name: "AlcoholTrackerCore", targets: ["AlcoholTrackerCore"]),
    ],
    targets: [
        .target(
            name: "AlcoholTrackerCore",
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
            ]
        ),
        .testTarget(
            name: "AlcoholTrackerCoreTests",
            dependencies: ["AlcoholTrackerCore"]
        ),
    ]
)
