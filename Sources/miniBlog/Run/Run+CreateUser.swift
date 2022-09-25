import ArgumentParser
import Logging

import class ConsoleKit.Terminal

extension Run {
    struct CreateUser: AsyncParsableCommand {
        @OptionGroup var commonOptions: Run.CommonOptions

        func run() async throws {
            let environment = commonOptions.environment

            LoggingSystem.bootstrap(from: commonOptions)
            let config = Blog.Configuration()

            let terminal = Terminal()
            let name = terminal.prompt("Name")
            let email = terminal.prompt("Email")
            let username = terminal.prompt("Username")
            let password = Secret(terminal.securePrompt("Password"))

            let blog = try await Blog.prepare(configuration: config, environment: environment)
            try await blog.createUser(name: name, email: email, username: username, password: password)
        }
    }
}

extension ConsoleKit.Terminal {
    func secureInput() -> String {
        input(isSecure: true)
    }

    func prompt(_ message: String) -> String {
        output("\(message): ", newLine: false)
        return input()
    }

    func securePrompt(_ message: String) -> String {
        output("\(message): ", newLine: false)
        return secureInput()
    }
}
