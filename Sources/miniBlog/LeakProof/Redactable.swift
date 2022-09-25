/// A protocol indicating a type is redactable.
protocol Redactable {
    /// A replacement value that will be used when redacting values of this type.
    var redactionReplacement: Self { get }
}
