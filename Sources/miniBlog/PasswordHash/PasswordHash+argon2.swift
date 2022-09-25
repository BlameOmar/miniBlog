import Argon2Swift

extension PasswordHash {
    static func argon2i(_ password: Secret<String>) throws -> PasswordHash {
        .init(algorithm: .argon2i, hash: try Argon2i.hash(plaintext: password.secretValue))
    }

    func verifyArgon2i(password: Secret<String>) throws -> Bool {
        try Argon2i.verify(plaintext: password.secretValue, hash: hash)
    }

    static func argon2d(_ password: Secret<String>) throws -> PasswordHash {
        .init(algorithm: .argon2d, hash: try Argon2id.hash(plaintext: password.secretValue))
    }

    func verifyArgon2d(password: Secret<String>) throws -> Bool {
        try Argon2d.verify(plaintext: password.secretValue, hash: hash)
    }

    static func argon2id(_ password: Secret<String>) throws -> PasswordHash {
        .init(algorithm: .argon2id, hash: try Argon2id.hash(plaintext: password.secretValue))
    }

    func verifyArgon2id(password: Secret<String>) throws -> Bool {
        try Argon2id.verify(plaintext: password.secretValue, hash: hash)
    }
}
