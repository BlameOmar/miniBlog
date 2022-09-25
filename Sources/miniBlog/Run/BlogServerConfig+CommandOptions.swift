import Foundation
import WebURL

extension Blog.Configuration {
    init(httpServerOptions: Run.Serve.HTTPServerOptions? = nil) {
        let httpServerConfig: HTTPServerConfiguration
        if let httpServerOptions = httpServerOptions {
            httpServerConfig = HTTPServerConfiguration(
                port: httpServerOptions.port,
                rootDirectory: httpServerOptions.httpRoot.map { try! WebURL(filePath: $0) }
            )
        } else {
            httpServerConfig = .default
        }

        self.init(
            databaseConfiguration: DatabaseConfiguration(
                host: Environment.parameters["DATABASE_HOST"] ?? "localhost",
                username: Environment.parameters["DATABASE_USERNAME"] ?? ProcessInfo.processInfo.userName,
                password: Environment.parameters["SECRET_DATABASE_PASSWORD"] ?? "",
                database: Environment.parameters["DATABASE_NAME"] ?? "miniblog"
            ),
            httpServerConfiguration: httpServerConfig
        )
    }
}
