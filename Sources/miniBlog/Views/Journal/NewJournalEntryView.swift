import SafeHTML

struct NewJournalEntryView: AuthAwareView {
    let authenticatedUser: User?

    @HTMLBuilder var body: HTMLSafeString {
        DefaultPageTemplate(title: "Hello", authenticatedUser: authenticatedUser) {
            "Write a new Journal Entry (Write Mode)"
        }
    }
}
