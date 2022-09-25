import Foundation
import WebURL

/// A type representing the runtime environment of the program.
///
/// Environments have a type and optionally a name.
struct Environment {
    /// A type indicating a program's environment type.
    enum EnvironmentType: String {
        case development
        case testing
        case staging
        case production
    }

    /// The environment's type.
    ///
    /// An environment's type may be used to set default values for configuration (such as logging/tracing behavior).
    let type: EnvironmentType

    /// The environment's name (optional).
    ///
    /// An environment may be given a name to distinguish it from other environments of the same type in logs and status
    /// pages.
    let name: String?

    /// Creates an environment with a specified type and optional name.
    init(type: EnvironmentType, name: String? = nil) {
        self.type = type
        self.name = name
    }

    /// An unnamed development environment.
    static let development = Environment(type: .development)

    /// An unnamed testing environment.
    static let testing = Environment(type: .testing)

    /// An unnamed staging environment.
    static let staging = Environment(type: .staging)

    /// An unnamed production environment.
    static let production = Environment(type: .production)
}

extension Environment: CustomStringConvertible {
    /// A string containing the environment's type and name.
    var description: String {
        name == nil ? type.rawValue : "\(type.rawValue)-\(name!)"
    }
}

extension Environment {
    static var workingDirectory: WebURL { try! .init(filePath: FileManager.default.currentDirectoryPath) }
}

extension Environment {
    /// Provides access to the program's runtime environment variables.
    struct Parameters {
        /// Returns the specified runtime environment parameter.
        ///
        /// - Parameter name: The name of the environment parameter.
        /// - Returns: The specified parameter if its set; otherwise nil.
        subscript(name: String) -> String? {
            processEnvironment[name]
        }

        var processEnvironment: [String: String] { ProcessInfo.processInfo.environment }
    }

    /// The runtime environment variables.
    static let parameters = Parameters()
}

extension Environment.Parameters: Sequence {
    typealias Element = Dictionary<String, String>.Element
    typealias Iterator = Array<Element>.Iterator
    func makeIterator() -> Iterator {
        processEnvironment.sorted(by: <).makeIterator()
    }
}
