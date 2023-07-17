// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "miniBlog",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-format.git", from: "508.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-markdown.git", from: "0.2.0"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.0.0"),
        .package(url: "https://github.com/BlameOmar/argon2.git", branch: "main"),
        .package(url: "https://github.com/gumob/PunycodeSwift.git", from: "2.0.0"),
        .package(url: "https://github.com/karwa/swift-url.git", from: "0.4.0"),
        .package(url: "https://github.com/MrLotU/SwiftPrometheus.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "miniBlog",
            dependencies: [
                "Argon2Swift",
                "FoundationExtras",
                "SafeHTML",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Markdown", package: "swift-markdown"),
                .product(name: "Metrics", package: "swift-metrics"),
                .product(name: "Punnycode", package: "PunycodeSwift"),
                .product(name: "SwiftPrometheus", package: "SwiftPrometheus"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "WebURL", package: "swift-url"),
            ]),
        .testTarget(
            name: "miniBlogTests",
            dependencies: ["miniBlog"]),
        .target(
            name: "Argon2Swift",
            dependencies: [
                "SwiftExtras",
                .product(name: "argon2", package: "argon2")
            ]),
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
        .target(
            name: "SwiftExtras",
            dependencies: []),
    ]
)
