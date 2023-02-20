import SafeHTML

struct ManageJournalEntriesView: AuthAwareView {
    let authenticatedUser: User?
    let blogConfiguration: BlogConfiguration

    @HTMLBuilder var body: HTMLSafeString {
        DefaultPageTemplate(title: "Hello", authenticatedUser: authenticatedUser, blogConfiguration: blogConfiguration) {
            "Manages Journal Entries (Publisher Mode)"
        }
    }
}
