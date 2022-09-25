import SafeHTML

struct ListJournalEntriesView: AuthAwareView {
    let authenticatedUser: User?

    @HTMLBuilder var body: HTMLSafeString {
        DefaultPageTemplate(title: "Hello", authenticatedUser: authenticatedUser) {
            "Lists Journal Entries (Read Mode)"
        }
    }
}
