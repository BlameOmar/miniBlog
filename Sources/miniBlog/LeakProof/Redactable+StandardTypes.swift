/// Adds conformances to Redactable for some Standard Library types.

extension Optional: Redactable {
    // Optional values are always redacted to nil.
    var redactionReplacement: Wrapped? {
        nil
    }
}

extension String: Redactable {
    // A string indicating that the original value has been redacted.
    var redactionReplacement: String {
        // TODO: There may be value in localizing this string.
        "[redacted]"
    }
}
