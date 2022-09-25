import ArgumentParser
import Logging

@main
struct Run: AsyncParsableCommand {
    typealias Command = Run

    static var configuration = CommandConfiguration(
        commandName: "blog",
        abstract: "A command line utility for serving and managing the blog.",
        subcommands: [Serve.self, CreateUser.self],
        defaultSubcommand: Serve.self)
}

extension Run {
    struct CommonOptions: ParsableArguments {
        @Option(help: "The type of environment.")
        var environment: Environment = .development

        @Option(help: "The default log level")
        var logLevel: Logger.Level?
    }
}

extension Logger.Level: ExpressibleByArgument {
    // FIXME: Multiple matching initializers (protocol extensions for LosslessStringConvertible and RawRepresentable)
    public init?(argument: String) {
        self.init(rawValue: argument)
    }
}
