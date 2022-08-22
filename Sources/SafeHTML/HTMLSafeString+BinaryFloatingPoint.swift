// TODO: [BLOCKED] Make initializers/interpolation fully generic.
// This is blocked on support for formatting arbitrary BinaryFloatingPoint types in the Swift Standard Library
// and/or Swift Numerics.

extension HTMLSafeString {
    #if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
    /// Creates an HTMLSafeString containing the string representation of a Float16.
    public init(_ value: Float16) {
        storage = String(describing: value)
    }
    #endif

    /// Creates an HTMLSafeString containing the string representation of a Float32.
    public init(_ value: Float32) {
        storage = String(describing: value)
    }

    /// Creates an HTMLSafeString containing the string representation of a Float64.
    public init(_ value: Float64) {
        storage = String(describing: value)
    }

    /// Creates an HTMLSafeString containing the string representation of an arbitrary BinaryFloatingPoint.
    public init<T>(_ value: T) where T: BinaryFloatingPoint {
        self.init(escaping: String(describing: value))
    }
}

extension HTMLSafeString.HTMLSafeStringInterpolation {
    #if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
    public mutating func appendInterpolation(_ value: Float16) {
        appendInterpolation(HTMLSafeString(value))
    }
    #endif

    public mutating func appendInterpolation(_ value: Float32) {
        appendInterpolation(HTMLSafeString(value))
    }

    public mutating func appendInterpolation(_ value: Float64) {
        appendInterpolation(HTMLSafeString(value))
    }

    public mutating func appendInterpolation<T>(_ value: T) where T: BinaryFloatingPoint {
        appendInterpolation(HTMLSafeString(value))
    }
}
