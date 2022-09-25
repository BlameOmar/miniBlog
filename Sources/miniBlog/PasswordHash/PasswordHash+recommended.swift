extension PasswordHash {
    static func recommended(_ password: Secret<String>) throws -> PasswordHash {
        try .argon2id(password)
    }
}
