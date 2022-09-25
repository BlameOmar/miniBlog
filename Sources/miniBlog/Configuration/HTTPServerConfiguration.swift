import WebURL

struct HTTPServerConfiguration: Codable {
    let rootDirectory: WebURL
    let port: Int

    init(port: Int, rootDirectory: WebURL? = nil) {
        self.port = port
        self.rootDirectory = rootDirectory ?? Self.defaultRootDirectory
    }

    static var `default` = HTTPServerConfiguration(port: 8080)

    static var defaultRootDirectory: WebURL {
        var value = Environment.workingDirectory
        value.pathComponents.append("Public")
        return value
    }
}
