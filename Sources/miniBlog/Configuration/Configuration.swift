import DefaultCodable
import Foundation
import Vapor
import WebURL
import WebURLFoundationExtras
import Yams

struct Configuration: Codable {
    var application: ApplicationConfiguration
    
    enum CodingKeys: String, CodingKey {
        case application = "dev.omarevans.miniBlog"
    }
}

struct ApplicationConfiguration: Codable {
    @Default<HTTPServerConfiguration>
    var httpServerConfiguration: HTTPServerConfiguration
    
    @Default<BlogConfiguration>
    var blogConfiguration: BlogConfiguration
    
    @Default<DatabaseConfiguration>
    var databaseConfiguration: DatabaseConfiguration
    
    enum CodingKeys: String, CodingKey {
        case blogConfiguration = "blog"
        case databaseConfiguration = "database"
        case httpServerConfiguration = "http"
    }
    
    init() {}
    
    init(httpServerConfiguration: HTTPServerConfiguration? = nil,
         databaseConfiguration: DatabaseConfiguration? = nil,
         blogConfiguration: BlogConfiguration? = nil) {
        _httpServerConfiguration = .init(optionalValue: httpServerConfiguration)
        _databaseConfiguration = .init(optionalValue: databaseConfiguration)
        _blogConfiguration = .init(optionalValue: blogConfiguration)
    }
}

extension ApplicationConfiguration {
  enum StorageKey: Vapor.StorageKey {
    typealias Value = ApplicationConfiguration
  }
}


struct BlogConfiguration: Codable, DefaultValueProvider {
    enum DefaultName: DefaultValueProvider {
        public static let `default`: String = "miniBlog"
    }
    enum DefaultURL: DefaultValueProvider {
        public static let `default`: WebURL = WebURL("http://localhost:8080")!
    }
    
    @Default<DefaultName>
    var name: String
    
    @Default<DefaultURL>
    var url: WebURL
    
    static var `default`: Self {
        .init()
    }
}

struct ConfigurationReader {
    static func getConfiguration() throws -> Configuration {
        var wd = Environment.workingDirectory
        wd.pathComponents += ["Configuration", "config.yaml"]
        let configData = try Data(contentsOf: wd)
        let decoder = YAMLDecoder()
        let config = try decoder.decode(Configuration.self, from: configData)
        
        return config
    }
}

extension Default: CustomStringConvertible {
    public var description: String {
        String(describing: wrappedValue)
    }
}

extension Default: CustomDebugStringConvertible {
    public var debugDescription: String {
        String(reflecting: wrappedValue)
    }
}
