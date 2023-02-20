import SafeHTML

struct ListJournalEntriesView: AuthAwareView {
    let authenticatedUser: User?
    let blogConfiguration: BlogConfiguration

    @HTMLBuilder var body: HTMLSafeString {
        DefaultPageTemplate(title: "Hello", authenticatedUser: authenticatedUser, blogConfiguration: blogConfiguration) {
            "Lists Journal Entries (Read Mode)"
        }
    }
}
