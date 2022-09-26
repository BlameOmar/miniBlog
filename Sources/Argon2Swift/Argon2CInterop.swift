import argon2

typealias CArgon2HashEncoderFunction = @convention(c) (
    _ timeCost: UInt32,
    _ memoryCost: UInt32,
    _ threadCount: UInt32,
    _ password: UnsafeRawPointer,
    _ passwordLength: Int,
    _ salt: UnsafeRawPointer,
    _ saltLength: Int,
    _ hashLength: Int,
    _ output: UnsafeMutablePointer<CChar>,
    _ outputLength: Int
) -> Int32

typealias CArgon2HashVerificationFunction = @convention(c) (
    _ encoded: UnsafePointer<CChar>,
    _ password: UnsafeRawPointer,
    _ passwordLength: Int
) -> Int32

extension Argon2Status: Error {
    public init(_ value: Int32) {
        self.init(rawValue: value)!
    }
}

protocol CArgon2Encoder {
    static var argon2Type: Argon2Type { get }
    static var hashEncoder: CArgon2HashEncoderFunction { get }
    static var hashVerification: CArgon2HashVerificationFunction { get }
    static func encode(
        _ timeCost: UInt32,
        _ memoryCost: UInt32,
        _ threadCount: UInt32,
        _ secret: UnsafeRawPointer,
        _ secretLength: Int,
        _ salt: UnsafeRawPointer,
        _ saltLength: Int,
        _ hashLength: Int,
        _ output: UnsafeMutablePointer<CChar>,
        _ outputLength: Int
    ) -> Int32
    static func verify(_ encoded: UnsafePointer<CChar>, _ password: UnsafeRawPointer, _ passwordLength: Int) -> Int32
}

extension CArgon2Encoder {
    static func encode(
        _ timeCost: UInt32,
        _ memoryCost: UInt32,
        _ threadCount: UInt32,
        _ secret: UnsafeRawPointer,
        _ secretLength: Int,
        _ salt: UnsafeRawPointer,
        _ saltLength: Int,
        _ hashLength: Int,
        _ output: UnsafeMutablePointer<CChar>,
        _ outputLength: Int
    ) -> Int32 {
        return hashEncoder(
            timeCost,
            memoryCost,
            threadCount,
            secret,
            secretLength,
            salt,
            saltLength,
            hashLength,
            output,
            outputLength)
    }

    static func verify(
        _ encoded: UnsafePointer<CChar>,
        _ password: UnsafeRawPointer,
        _ passwordLength: Int
    ) -> Int32 {
        return hashVerification(encoded, password, passwordLength)
    }
}

struct CArgon2iEncoder: CArgon2Encoder {
    static let argon2Type: Argon2Type = .argon2i
    static let hashEncoder: CArgon2HashEncoderFunction = argon2i_hash_encoded
    static let hashVerification: CArgon2HashVerificationFunction = argon2i_verify
}

struct CArgon2dEncoder: CArgon2Encoder {
    static let argon2Type: Argon2Type = .argon2d
    static let hashEncoder: CArgon2HashEncoderFunction = argon2d_hash_encoded
    static let hashVerification: CArgon2HashVerificationFunction = argon2d_verify
}

struct CArgon2idEncoder: CArgon2Encoder {
    static let argon2Type: Argon2Type = .argon2id
    static let hashEncoder: CArgon2HashEncoderFunction = argon2id_hash_encoded
    static let hashVerification: CArgon2HashVerificationFunction = argon2id_verify
}

func argon2<E: CArgon2Encoder>(
    password: String, salt: [UInt8], timeCost: Int, memoryCost: Int, threadCount: Int, digestLength: Int,
    encoder: E.Type
) throws -> String {
    var password = password
    var salt = salt
    return try password.withUTF8 { passwordBuffer in
        try salt.withUnsafeMutableBytes { saltBuffer in
            let outputLength = argon2_encodedlen(
                UInt32(timeCost),
                UInt32(memoryCost),
                UInt32(threadCount),
                UInt32(saltBuffer.count),
                UInt32(digestLength),
                E.argon2Type)
            return try String(unsafeUninitializedCapacity: outputLength) { outputBuffer in
                try outputBuffer.withMemoryRebound(to: CChar.self) { outputBuffer in
                    let status = Argon2Status(
                        E.encode(
                            UInt32(timeCost),
                            UInt32(memoryCost),
                            UInt32(threadCount),
                            passwordBuffer.baseAddress!,
                            passwordBuffer.count,
                            saltBuffer.baseAddress!,
                            saltBuffer.count,
                            digestLength,
                            outputBuffer.baseAddress!,
                            outputBuffer.count
                        ))
                    guard status == .ok else {
                        throw status
                    }
                    return outputLength - 1  // Exclude the terminating null byte
                }
            }
        }
    }
}

func argon2Verify<E: CArgon2Encoder>(password: String, passwordHash: String, encoder: E.Type) throws -> Bool {
    var password = password
    return try passwordHash.withCString { passwordHashCString in
        try password.withUTF8 { passwordBuffer in
            let status = Argon2Status(E.verify(passwordHashCString, passwordBuffer.baseAddress!, passwordBuffer.count))
            switch status {
            case .ok:
                return true
            case .passwordDoesNotMatch:
                return false
            default:
                throw status
            }
        }
    }
}
