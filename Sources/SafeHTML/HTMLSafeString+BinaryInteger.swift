extension HTMLSafeString {
    /// Creates an HTMLSafeString containing the string representation of a `BinaryInteger`.
    ///
    /// Functions similarly to `String.init(_:radix:uppercase:)`
    ///
    /// - Parameters:
    ///   - value: The integer
    ///   - radix: The base to use for the string representation. Defaults to the usual base, 10.
    ///   - uppercase: Whether use uppercase letter to represent digits greater than 9. Defaults to false (lowercase).
    public init<T: BinaryInteger>(_ value: T, radix: Int = 10, uppercase: Bool = false) {
        storage = String(value, radix: radix, uppercase: uppercase)
    }
}

extension HTMLSafeString.HTMLSafeStringInterpolation {
    public mutating func appendInterpolation<T>(_ value: T) where T: BinaryInteger {
        appendInterpolation(HTMLSafeString(value))
    }

    public mutating func appendInterpolation<T>(_ value: T, radix: Int = 10, uppercase: Bool = false)
    where T: BinaryInteger {
        appendInterpolation(HTMLSafeString(value, radix: radix, uppercase: uppercase))
    }
}
