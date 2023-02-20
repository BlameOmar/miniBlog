import DefaultCodable
import WebURL

enum SocketAddress {
    case ip(address: String = "127.0.0.1", port: Int = 8080)
    case unix(path: String)
}

extension SocketAddress: Codable {}

struct HTTPServerConfiguration: Codable, DefaultValueProvider {
    enum DefaultSocketAddress: DefaultValueProvider {
        public static var `default`: SocketAddress = SocketAddress.ip( )
    }

    enum DefaultIPAddress: DefaultValueProvider {
        public static var `default`: String = ""
    }
    
    enum DefaultPort: DefaultValueProvider {
        public static var `default`: Int = 8080
    }
    
    enum DefaultRootDirectory: DefaultValueProvider {
        public static var `default`: WebURL = defaultRootDirectory
        private static var defaultRootDirectory: WebURL {
            var value = Environment.workingDirectory
            value.pathComponents.append("Public")
            return value
        }
    }

    @Default<DefaultPort>
    var port: Int
    
    @Default<DefaultRootDirectory>
    var rootDirectory: WebURL

    init() {}
    
    init(port: Int? = nil, rootDirectory: WebURL? = nil) {
        self._port = .init(optionalValue: port)
        self._rootDirectory = .init(optionalValue: rootDirectory)
    }

    static var `default`: Self = .init()
}
