// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swiftymocky",
    platforms: [
        .iOS("16.6"),
        .macOS("12.4"),
        .tvOS("16.6"),
    ],
    products: [
        // XCTest Runtime libraries
        .library(name: "SwiftyMocky", targets: ["SwiftyMocky"]),
        .library(name: "SwiftyPrototype", targets: ["SwiftyPrototype"]),
        // CLI Executable
        .executable(name: "swiftymocky", targets: ["SwiftyMockyCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/ShellOut", .upToNextMajor(from: "2.3.0")),
        .package(url: "https://github.com/tuist/xcodeproj", .upToNextMajor(from: "8.3.1")),
        .package(url: "https://github.com/luoxiu/Chalk", .exact("0.2.1")),
        .package(url: "https://github.com/kylef/Commander", .upToNextMajor(from: "0.9.1")),
        .package(url: "https://github.com/kylef/PathKit", .upToNextMajor(from: "1.0.1")),
        .package(url: "https://github.com/jpsim/Yams", .upToNextMajor(from: "5.0.1")),
    ],
    targets: [
        // XCTest Runtime libraries
        .target(
            name: "SwiftyMocky",
            path: "./Sources/SwiftyMocky",
            exclude: ["Mock.swifttemplate"]
        ),
        .target(
            name: "SwiftyPrototype",
            path: "./Sources/SwiftyPrototype",
            exclude: ["Prototype.swifttemplate"]
        ),
        .target(
            name: "Shared",
            path: "./Sources/Shared"
        ),
        // Example and tests
        .target(
            name: "Mocky_Example_macOS",
            path: "./SwiftyMocky-Example/Shared"
        ),
        .testTarget(
            name: "SwiftyMockyTests",
            dependencies: ["Mocky_Example_macOS", "SwiftyMocky"],
            path: "./Tests/SwiftyMockyTests"
        ),
        .testTarget(
            name: "RuntimeLibraryTests",
            dependencies: ["SwiftyMocky"]
        ),
        // CLI Executable
        .target(
            name: "SwiftyMockyCLI",
            dependencies: [
                "Commander",
                "SwiftyMockyCLICore",
            ],
            path: "./Sources/CLI/App"
        ),
        .target(
            name: "SwiftyMockyCLICore",
            dependencies: [
                "ShellOut",
                "Chalk",
                "XcodeProj",
                "PathKit",
                "Yams",
            ],
            path: "./Sources/CLI/Core"
        ),
        .testTarget(
           name: "SwiftyMockyCLICoreTests",
           dependencies: [
               "SwiftyMockyCLICore",
               "SwiftyMocky",
           ]
        ),
    ]
)
