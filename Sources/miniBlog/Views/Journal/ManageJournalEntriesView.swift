import SafeHTML

struct ManageJournalEntriesView: AuthAwareView {
    let authenticatedUser: User?

    @HTMLBuilder var body: HTMLSafeString {
        DefaultPageTemplate(title: "Hello", authenticatedUser: authenticatedUser) {
            "Manages Journal Entries (Publisher Mode)"
        }
    }
}
