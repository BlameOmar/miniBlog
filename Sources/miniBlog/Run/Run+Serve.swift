import ArgumentParser
import Backtrace
import Foundation
import Logging
import Metrics
import Prometheus
import WebURL

import class ConsoleKit.Terminal

extension Run {
    struct Serve: AsyncParsableCommand {
        struct HTTPServerOptions: ParsableArguments {
            @Option(help: "The serving port.")
            var port: Int?

            @Option(help: "The serving directory.")
            var httpRoot: String?
        }

        @OptionGroup var commonOptions: Run.CommonOptions
        @OptionGroup var httpServerOptions: HTTPServerOptions

        func run() async throws {
            Backtrace.install()
            
            let environment = commonOptions.environment

            LoggingSystem.bootstrap(from: commonOptions)
            MetricsSystem.bootstrap(PrometheusMetricsFactory(client: PrometheusClient()))

            var configuration = try ConfigurationReader.getConfiguration()
            
            if let port = httpServerOptions.port {
                configuration.application.httpServerConfiguration.port = port
            }
            if let rootDir = httpServerOptions.httpRoot {
                configuration.application.httpServerConfiguration.rootDirectory = try WebURL(filePath: rootDir)
            }

            let blog = try await Blog.prepare(configuration: configuration.application, environment: environment)

            try blog.run()
        }
    }
}

extension LoggingSystem {
    static func bootstrap(from options: Run.CommonOptions) {
        bootstrap { label in
            var handler = StreamLogHandler.standardError(label: label)
            handler.logLevel =
                options.logLevel ?? Environment.parameters["LOG_LEVEL"] ?? .recommended(for: options.environment.type)
            return handler
        }
    }
}
