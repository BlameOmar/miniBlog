struct PasswordHash {
    enum HashAlgorithm: String, CaseIterable {
        case argon2i = "$argon2i$"
        case argon2d = "$argon2d$"
        case argon2id = "$argon2id$"
    }

    let algorithm: HashAlgorithm
    let hash: String
}

extension PasswordHash.HashAlgorithm {
    var hashPrefix: String {
        rawValue
    }
}

extension PasswordHash: CustomStringConvertible {
    var description: String {
        hash.description
    }
}

extension PasswordHash: CustomDebugStringConvertible {
    var debugDescription: String {
        #"PasswordHash(algorithm: .\#(algorithm), hash: "\#(self.hash)")"#
    }
}

extension PasswordHash: Encodable {
    func encode(to encoder: Encoder) throws {
        try hash.encode(to: encoder)
    }
}

extension PasswordHash: Decodable {
    enum DecodeError: Error {
        case unsupportedHashAlgorithm
    }

    init(rawHash: String) throws {
        guard let detected = HashAlgorithm.allCases.first(where: { rawHash.starts(with: $0.hashPrefix) }) else {
            throw DecodeError.unsupportedHashAlgorithm
        }
        self.init(algorithm: detected, hash: rawHash)
    }

    init?(_ hash: String) {
        try? self.init(rawHash: hash)
    }

    init(from decoder: Decoder) throws {
        let rawHash = try String(from: decoder)
        try self.init(rawHash: rawHash)
    }
}
