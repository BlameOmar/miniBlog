import Foundation
import WebURL

extension ApplicationConfiguration {
    init(httpServerOptions: Run.Serve.HTTPServerOptions) {
        self.init(httpServerConfiguration: .init(
            port: httpServerOptions.port,
            rootDirectory: httpServerOptions.httpRoot.map { try! WebURL(filePath: $0) }
        ))
    }
}
