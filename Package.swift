// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "miniBlog",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-format", branch: "release/5.6"),
        .package(url: "https://github.com/gumob/PunycodeSwift.git", from: "2.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "miniBlog",
            dependencies: [
                "FoundationExtras",
                "SafeHTML",
                .product(name: "Punnycode", package: "PunycodeSwift"),
            ]),
        .testTarget(
            name: "miniBlogTests",
            dependencies: ["miniBlog"]),
        .target(
            name: "FoundationExtras",
            dependencies: []),
        .testTarget(
            name: "FoundationExtrasTests",
            dependencies: ["FoundationExtras"]),
        .target(
            name: "SafeHTML",
            dependencies: []),
        .testTarget(
            name: "SafeHTMLTests",
            dependencies: [
                "SafeHTML",
                .product(name: "Collections", package: "swift-collections"),
            ]),
        .plugin(
            name: "SwiftFormatterPlugin",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [
                    .writeToPackageDirectory(reason: "This command reformats source files")
                ]),
            dependencies: [
                .product(name: "swift-format", package: "swift-format")
            ]),
    ]
)
