import SafeHTML

struct NewJournalEntryView: AuthAwareView {
    let authenticatedUser: User?
    let blogConfiguration: BlogConfiguration

    @HTMLBuilder var body: HTMLSafeString {
        DefaultPageTemplate(title: "Hello", authenticatedUser: authenticatedUser, blogConfiguration: blogConfiguration) {
            "Write a new Journal Entry (Write Mode)"
        }
    }
}
