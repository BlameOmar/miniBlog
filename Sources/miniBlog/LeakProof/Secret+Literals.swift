extension Secret: ExpressibleByBooleanLiteral where Wrapped: ExpressibleByBooleanLiteral {
    typealias BooleanLiteralType = Wrapped.BooleanLiteralType

    init(booleanLiteral value: BooleanLiteralType) {
        self.init(Wrapped(booleanLiteral: value))
    }
}

extension Secret: ExpressibleByIntegerLiteral where Wrapped: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Wrapped.IntegerLiteralType

    init(integerLiteral value: IntegerLiteralType) {
        self.init(Wrapped(integerLiteral: value))
    }
}

extension Secret: ExpressibleByFloatLiteral where Wrapped: ExpressibleByFloatLiteral {
    typealias FloatLiteralType = Wrapped.FloatLiteralType

    init(floatLiteral value: FloatLiteralType) {
        self.init(Wrapped(floatLiteral: value))
    }
}

extension Secret: ExpressibleByUnicodeScalarLiteral where Wrapped: ExpressibleByUnicodeScalarLiteral {
    typealias UnicodeScalarLiteralType = Wrapped.UnicodeScalarLiteralType

    init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(Wrapped(unicodeScalarLiteral: value))
    }
}

extension Secret: ExpressibleByExtendedGraphemeClusterLiteral
where Wrapped: ExpressibleByExtendedGraphemeClusterLiteral {
    typealias ExtendedGraphemeClusterLiteralType = Wrapped.ExtendedGraphemeClusterLiteralType

    init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(Wrapped(extendedGraphemeClusterLiteral: value))
    }
}

extension Secret: ExpressibleByStringLiteral where Wrapped: ExpressibleByStringLiteral {
    typealias StringLiteralType = Wrapped.StringLiteralType

    init(stringLiteral value: StringLiteralType) {
        self.init(Wrapped(stringLiteral: value))
    }
}
