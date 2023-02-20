// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "miniBlog",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0"),
//        .package(url: "https://github.com/apple/swift-format", from: "0.50700.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-markdown", branch: "release/5.7"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.0.0"),
        .package(url: "https://github.com/BlameOmar/argon2", branch: "main"),
        .package(url: "https://github.com/BlameOmar/DefaultCodable", branch: "wip/2.0"),
        .package(url: "https://github.com/gumob/PunycodeSwift.git", from: "2.1.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.1"),
        .package(url: "https://github.com/karwa/swift-url", from: "0.4.0"),
        .package(url: "https://github.com/MrLotU/SwiftPrometheus.git", from: "1.0.0-alpha"),
        .package(url: "https://github.com/swift-server/swift-backtrace.git", from: "1.3.3"),
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
                .product(name: "Backtrace", package: "swift-backtrace"),
                .product(name: "DefaultCodable", package: "DefaultCodable"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Markdown", package: "swift-markdown"),
                .product(name: "Metrics", package: "swift-metrics"),
                .product(name: "Punnycode", package: "PunycodeSwift"),
                .product(name: "SwiftPrometheus", package: "SwiftPrometheus"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "WebURL", package: "swift-url"),
                .product(name: "WebURLFoundationExtras", package: "swift-url"),
                .product(name: "Yams", package: "Yams"),
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
//        .plugin(
//            name: "SwiftFormatterPlugin",
//            capability: .command(
//                intent: .sourceCodeFormatting(),
//                permissions: [
//                    .writeToPackageDirectory(reason: "This command reformats source files")
//                ]),
//            dependencies: [
//                .product(name: "swift-format", package: "swift-format")
//            ]),
    ]
)
