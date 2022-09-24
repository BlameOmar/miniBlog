import SwiftExtras

public struct KiB {
    public let kibibytes: Int

    public init(_ kibibytes: Int) {
        self.kibibytes = kibibytes
    }

    public static func MiB(_ m: Int) -> Self {
        .init(m * 1024)
    }

    public static func GiB(_ g: Int) -> Self {
        .init(g * 1_048_576)
    }
}

extension KiB: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

public struct Argon2Configuration {
    public let timeCost: Int
    public let memoryCost: KiB
    public let threadCount: Int
    public let digestLength: Int

    public static let defaultConfig: Self = .init(timeCost: 3, memoryCost: .MiB(64), threadCount: 4, digestLength: 32)
}

public enum Argon2i {
    public static func hash(plaintext: String, config: Argon2Configuration = .defaultConfig) throws -> String {
        try hash(plaintext: plaintext, salt: .random(count: 16), config: config)
    }
    public static func hash(plaintext: String, salt: [UInt8], config: Argon2Configuration = .defaultConfig) throws
        -> String
    {
        try argon2(
            password: plaintext, salt: salt, timeCost: config.timeCost, memoryCost: config.memoryCost.kibibytes,
            threadCount: config.threadCount,
            digestLength: config.digestLength, encoder: CArgon2iEncoder.self)
    }
    public static func verify(plaintext: String, hash: String) throws -> Bool {
        try argon2Verify(password: plaintext, passwordHash: hash, encoder: CArgon2iEncoder.self)
    }
}

public enum Argon2d {
    public static func hash(plaintext: String, config: Argon2Configuration = .defaultConfig) throws -> String {
        try hash(plaintext: plaintext, salt: .random(count: 16), config: config)
    }

    public static func hash(plaintext: String, salt: [UInt8], config: Argon2Configuration = .defaultConfig) throws
        -> String
    {
        try argon2(
            password: plaintext, salt: salt, timeCost: config.timeCost, memoryCost: config.memoryCost.kibibytes,
            threadCount: config.threadCount,
            digestLength: config.digestLength, encoder: CArgon2dEncoder.self)
    }
    public static func verify(plaintext: String, hash: String) throws -> Bool {
        try argon2Verify(password: plaintext, passwordHash: hash, encoder: CArgon2dEncoder.self)
    }
}

public enum Argon2id {
    public static func hash(plaintext: String, config: Argon2Configuration = .defaultConfig) throws -> String {
        try hash(plaintext: plaintext, salt: .random(count: 16), config: config)
    }

    public static func hash(plaintext: String, salt: [UInt8], config: Argon2Configuration = .defaultConfig) throws
        -> String
    {
        try argon2(
            password: plaintext, salt: salt, timeCost: config.timeCost, memoryCost: config.memoryCost.kibibytes,
            threadCount: config.threadCount,
            digestLength: config.digestLength, encoder: CArgon2idEncoder.self)
    }
    public static func verify(plaintext: String, hash: String) throws -> Bool {
        try argon2Verify(password: plaintext, passwordHash: hash, encoder: CArgon2idEncoder.self)
    }
}
