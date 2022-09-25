import Logging

extension Logger.Level {
    /// Returns the recommended log level for a specified environment type.
    static func recommended(for environmentType: Environment.EnvironmentType) -> Self {
        environmentType == .production ? .notice : .info
    }
}
