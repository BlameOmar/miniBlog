/// A wrapper for secret values.
///
/// Use `Secret` to guard against the leaking of secret information outside of the application (such as in logs and
/// rendered templates). `Secret` uses the `Redactable` protocol to redact the wrapped value when it is being converted
/// to a `String` (such as in log statements) or when being encoded using the `Encodable` protocol. Additionally,
/// Swift's type safety ensures it is impossible to accidentally assign a wrapped `Secret` to a non-secret variable
/// or function parameter.
struct Secret<T: Redactable> {
    typealias Wrapped = T
    init(_ value: Wrapped) {
        wrappedValue = value
    }

    /// Accesses the secret value.
    var secretValue: Wrapped {
        wrappedValue
    }

    private let wrappedValue: Wrapped
}

extension Secret: CustomStringConvertible {
    var description: String {
        String(describing: wrappedValue.redactionReplacement)
    }
}

extension Secret: CustomDebugStringConvertible {
    var debugDescription: String {
        String(reflecting: wrappedValue.redactionReplacement)
    }
}

extension Secret: Encodable where Wrapped: Encodable {
    func encode(to encoder: Encoder) throws {
        try wrappedValue.redactionReplacement.encode(to: encoder)
    }
}

extension Secret: Decodable where Wrapped: Decodable {
    init(from decoder: Decoder) throws {
        try self.init(Wrapped(from: decoder))
    }
}
