import Vapor

extension Blog {
    func register(publicRoutes routes: RoutesBuilder) throws {
        // Redirect homepage to journal
        routes.get { $0.redirect(to: "journal", type: .temporary) }
        // Authentication
        routes.get("login") { $0.redirect(to: "/auth/login", type: .temporary) }
        routes.post("login") { $0.redirect(to: "/auth/login", type: .temporary) }
        routes.post("logout") { $0.redirect(to: "/auth/logout", type: .temporary) }
        try routes.grouped("auth").register(collection: AuthenticationController())
        try routes.grouped("journal").register(collection: JournalController())
        try routes.grouped("cms").register(collection: CMSJournalController())
        try routes.register(collection: UserController())
    }
}
