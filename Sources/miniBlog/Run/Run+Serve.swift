import ArgumentParser
import Foundation
import Logging
import Metrics
import Prometheus

import class ConsoleKit.Terminal

extension Run {
    struct Serve: AsyncParsableCommand {
        struct HTTPServerOptions: ParsableArguments {
            @Option(help: "The serving port.")
            var port: Int = 8080

            @Option(help: "The serving directory.")
            var httpRoot: String?
        }

        @OptionGroup var commonOptions: Run.CommonOptions
        @OptionGroup var httpServerOptions: HTTPServerOptions

        func run() async throws {
            let environment = commonOptions.environment

            LoggingSystem.bootstrap(from: commonOptions)
            MetricsSystem.bootstrap(PrometheusMetricsFactory(client: PrometheusClient()))

            let configuration = Blog.Configuration(httpServerOptions: httpServerOptions)
            let blog = try await Blog.prepare(configuration: configuration, environment: environment)

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
