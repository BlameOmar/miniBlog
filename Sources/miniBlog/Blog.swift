import Fluent
import FluentKit
import FluentPostgresDriver
import Foundation
import FoundationExtras
import Vapor

/// The blog application.
class Blog {
    /// Blog configuration.
    struct Configuration: Codable {
        let databaseConfiguration: DatabaseConfiguration
        let httpServerConfiguration: HTTPServerConfiguration
        init(
            databaseConfiguration: DatabaseConfiguration,
            httpServerConfiguration: HTTPServerConfiguration = HTTPServerConfiguration.default
        ) {
            self.databaseConfiguration = databaseConfiguration
            self.httpServerConfiguration = httpServerConfiguration
        }
    }

    /// Instantiates a blog.
    init(configuration: Configuration, environment: Environment) throws {
        self.configuration = configuration
        self.environment = environment
        app = Vapor.Application(Vapor.Environment(name: environment.description, arguments: ["vapor", "serve"]))
        app.databases.use(
            .postgres(
                configuration: SQLPostgresConfiguration(
                    hostname: configuration.databaseConfiguration.host,
                    username: configuration.databaseConfiguration.username,
                    password: configuration.databaseConfiguration.password.secretValue,
                    database: configuration.databaseConfiguration.database,
                    tls: .disable
                ),
                sqlLogLevel: .info
            ),
            as: .psql)

        app.directory.publicDirectory = configuration.httpServerConfiguration.rootDirectory.path
        app.http.server.configuration.port = configuration.httpServerConfiguration.port

        app.sessions.use(.memory)
        app.middleware.use(app.sessions.middleware)
        app.middleware.use(SessionAuthenticator())
        app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

        try registerRoutes()
    }

    static func prepare(configuration: Configuration, environment: Environment) async throws -> Blog {
        let blog = try Blog(configuration: configuration, environment: environment)
        blog.registerMigrations()
        try await blog.app.autoMigrate()
        try await CaseInsensitiveText.loadTypeInformation(from: blog.app.db(.psql) as! PostgresDatabase)
        return blog
    }

    /// Starts the server.
    func startServer(blockUntilShutdown: Bool = false) throws {
        startTime = Date()
        blockUntilShutdown ? try app.run() : try app.start()
    }

    /// Starts the server and blocks until it shuts down.
    func run() throws {
        try startServer(blockUntilShutdown: true)
    }

    deinit {
        if !app.didShutdown {
            app.shutdown()
        }
    }

    private func registerRoutes() throws {
        let routes = app.routes
        let internalRoutes = routes.grouped("_")

        try register(internalRoutes: internalRoutes)
        try register(publicRoutes: routes)
    }

    let configuration: Configuration
    let environment: Environment
    let app: Vapor.Application
    var startTime: Date?
}

extension Blog {
    /// Creates a user.
    ///
    /// This API exists for the CLI.
    ///
    /// - Parameters:
    ///   - name: The user's preferred name.
    ///   - email: The user's email address.
    ///   - username: A unique, (ideally) human readable identifier for the user.
    ///   - password: The user's password.
    /// - Throws:
    @Sendable
    func createUser(name: String, email: String, username: String, password: Secret<String>) async throws {
        // TODO: Factor out this logic to the controller layer (eg. an Admin controller).
        try await app.db.transaction { (database: Database) in
            let user = await User(id: .generate(), username: username, name: name, email: email)
            let password = try await Password(id: .generate(), user: user, password: password)
            try await user.create(on: database)
            try await password.create(on: database)
        }
    }
}
