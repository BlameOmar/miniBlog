/// An immutable Unicode string that may be safely used in HTML contexts, such as web pages rendered by browsers.
///
/// HTMLSafeString is designed to block script injection attacks. In addition to being immutable, one of the following properties is true for any HTMLSafeString:
///  * The HTMLSafeString was initalized from a literal value present in source code.
///  * The HTMLSafeString was initialized from a non-literal `String` value whose content was escaped.
///  * The HTMLSafeString is the result of concatenating two or more HTMLSafeStrings.
///  * The HTMLSafeString is the result of indenting another HTMLSafeString.
public struct HTMLSafeString: ExpressibleByStringLiteral {
    let storage: String

    var string: String {
        storage
    }

    /// Creates an empty string.
    ///
    /// Using this initializer is equivalent to initializing an HTMLSafeString with an empty string literal.
    /// ```
    /// let empty: HTMLSafeString = ""
    /// let alsoEmpty = HTMLSafeString()
    /// ```
    public init() {
        storage = String()
    }

    /// Creates an HTMLSafeString with the contents of another.
    ///
    /// Using this initializer is equivalent to intializing an HTMLSafeString by assignment.
    ///
    /// - Parameter value: The other string.
    ///
    /// ```
    /// let aString: HTMLSafeString = "<html><body>Hello world</body></html>"
    /// let aCopy = aString
    /// let alsoACopy = HTMLSafeString(aString)
    /// ```
    public init(_ value: HTMLSafeString) {
        storage = value.string
    }

    /// Creates an HTMLSafeString with the contents of a literal string.
    ///
    /// The requirement that the string literal be a StaticString blocks the use of this intitializer with non-literal strings.
    ///
    /// - Parameter value: A static string literal.
    ///
    public init(stringLiteral value: StaticString) {
        storage = String(value)
    }

    /// Creates an HTMLSafeString with the escaped contents of a `String` or `Substring`.
    ///
    /// Strings and Substrings may have been provided from an untrusted source. To prevent script injection, the following characters will be replaced with the
    /// corresponding XML named entity: `<`, `>`, `&`, `'`, `"`.
    ///
    /// - Parameter value: A string whose contents will be escaped.
    public init<StringType: StringProtocol>(escaping value: StringType) {
        storage = value.escapingXMLNamedEntities()
    }
}

extension HTMLSafeString {
    public enum IndentStyle {
        case tabs
        case spaces(count: Int)
    }
}

extension HTMLSafeString.IndentStyle {
    var string: String {
        switch self {
        case .tabs:
            return "\t"
        case .spaces(count: let numSpaces):
            return .init(repeating: " ", count: numSpaces)
        }
    }
}

extension HTMLSafeString {
    /// Creates an HTMLSafeString by indenting the lines of another one.
    ///
    /// - Parameters:
    ///   - value: The original string.
    ///   - times: How much to the new string should be indented.
    ///   - style: Whether to indent with tabs or a certain number of spaces.
    public init(indenting value: HTMLSafeString, times: Int = 1, style: IndentStyle = .spaces(count: 4)) {
        let lines = value.string.lazy.split(separator: "\n", omittingEmptySubsequences: false)
        let indentedLines = lines.lazy.map {
            $0.isEmpty ? String($0) : String(repeating: style.string, count: times) + $0
        }
        storage = indentedLines.joined(separator: "\n")
    }
}

extension HTMLSafeString: ExpressibleByStringInterpolation {
    public init(stringInterpolation: HTMLSafeStringInterpolation) {
        storage = stringInterpolation.string
    }

    public struct HTMLSafeStringInterpolation: StringInterpolationProtocol {
        private var segments = [String]()

        var string: String {
            segments.joined()
        }

        public init(literalCapacity: Int, interpolationCount: Int) {
            segments.reserveCapacity(2 * literalCapacity + 1)
        }

        public mutating func appendLiteral(_ literal: StaticString) {
            segments.append(String(literal))
        }

        public mutating func appendInterpolation(_ value: HTMLSafeString) {
            segments.append(value.string)
        }

        public mutating func appendInterpolation<S>(_ value: S) where S: StringProtocol {
            appendInterpolation(HTMLSafeString(escaping: value))
        }

        public mutating func appendInterpolation<T>(_ value: T) {
            appendInterpolation(HTMLSafeString(escaping: String(describing: value)))
        }
    }
}

extension HTMLSafeString: Encodable {
    public func encode(to encoder: Encoder) throws {
        try string.encode(to: encoder)
    }
}

extension HTMLSafeString: TextOutputStreamable {
    public func write<Target>(to target: inout Target) where Target: TextOutputStream {
        string.write(to: &target)
    }
}

extension HTMLSafeString: CustomStringConvertible {
    public var description: String {
        string.description
    }
}

extension HTMLSafeString: CustomDebugStringConvertible {
    public var debugDescription: String {
        string.debugDescription
    }
}

extension HTMLSafeString: Comparable {
    public static func < (left: HTMLSafeString, right: HTMLSafeString) -> Bool {
        left.string < right.string
    }
}

extension HTMLSafeString: Hashable {}
