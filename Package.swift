// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "miniBlog",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-format", branch: "release/5.6"),
    ],
    targets: [
        .executableTarget(
            name: "miniBlog",
            dependencies: []),
        .testTarget(
            name: "miniBlogTests",
            dependencies: ["miniBlog"]),
        .plugin(
            name: "SwiftFormatterPlugin",
            capability: .command(
                intent: .sourceCodeFormatting(),
                permissions: [
                    .writeToPackageDirectory(reason: "This command reformats source files")
                ]
            ),
            dependencies: [
                .product(name: "swift-format", package: "swift-format"),
            ]
        )
    ]
)
