extension PasswordHash {
    func matches(_ password: Secret<String>) throws -> Bool {
        switch algorithm {
        case .argon2i:
            return try verifyArgon2i(password: password)
        case .argon2d:
            return try verifyArgon2d(password: password)
        case .argon2id:
            return try verifyArgon2id(password: password)
        }
    }
}
