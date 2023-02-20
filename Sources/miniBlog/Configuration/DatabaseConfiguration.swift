import DefaultCodable
import Foundation

struct DatabaseConfiguration: Codable, DefaultValueProvider {
    enum DefaultHost: DefaultValueProvider {
        public static var `default`: String = Environment.parameters["DATABASE_HOST"] ?? "localhost"
    }
    
    enum DefaultUsername: DefaultValueProvider {
        public static var `default`: String = Environment.parameters["DATABASE_USERNAME"] ?? ProcessInfo.processInfo.userName
    }
    
    enum DefaultPassword: DefaultValueProvider {
        public static var `default`: Secret<String> = Environment.parameters["SECRET_DATABASE_PASSWORD"] ?? ""
    }
    
    enum DefaultDatabase: DefaultValueProvider {
        public static var `default`: String = Environment.parameters["DATABASE_NAME"] ?? "miniblog"
    }
    
    @Default<DefaultHost>
    var host: String
    
    @Default<DefaultUsername>
    var username: String
    
    @Default<DefaultPassword>
    var password: Secret<String>
    
    @Default<DefaultDatabase>
    var database: String

    init() {}
    
    init(host: String, username: String, password: Secret<String>, database: String) {
        self.host = host
        self.username = username
        self.password = password
        self.database = database
    }
    
    static let `default`: Self = .init()
}
