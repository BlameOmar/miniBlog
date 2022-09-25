import Foundation

extension HTMLSafeString.HTMLSafeStringInterpolation {
    public mutating func appendInterpolation(_ date: Date) {
        appendInterpolation(HTMLSafeString(escaping: ISO8601DateFormatter().string(from: date)))
    }

    public mutating func appendInterpolation(_ date: Date, formatter: DateFormatter) {
        appendInterpolation(HTMLSafeString(escaping: formatter.string(from: date)))
    }
}
