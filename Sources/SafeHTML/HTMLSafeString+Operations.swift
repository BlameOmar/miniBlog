extension HTMLSafeString {
    init(concatenating first: HTMLSafeString, with second: HTMLSafeString) {
        storage = first.string + second.string
    }

    init(joining strings: [HTMLSafeString], with separator: HTMLSafeString = "") {
        storage = strings.map { $0.string }.joined(separator: separator.string)
    }

    public static func + (left: HTMLSafeString, right: HTMLSafeString) -> HTMLSafeString {
        HTMLSafeString(concatenating: left, with: right)
    }
}

extension Array where Element == HTMLSafeString {
    public func joined(separator: HTMLSafeString = "") -> HTMLSafeString {
        HTMLSafeString(joining: self, with: separator)
    }
}
