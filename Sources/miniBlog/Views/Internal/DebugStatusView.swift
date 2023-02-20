import Foundation
import SafeHTML
import Vapor

extension BindAddress: Codable {}

struct DebugStatusView: HTMLView {
    let app: Blog

    init(app: Blog) {
        self.app = app
    }

    @HTMLBuilder var body: HTMLSafeString {
        let ba = BindAddress.hostname("0.0.0.0", port: 8080)
        let je = JSONEncoder()
        let json = try! je.encode(ba)
        
        """
        <title>Debug Status</title>
        <body>
        <h1>Status</h1>
        <table>
          <tr><td>Start time</td><td>\(app.startTime!)</td></tr>
          <tr><td>Profile</td><td>\(app.environment)</td></tr>
        </table>
        <h2>Environment Variables</h2>
        <table>
        """
        for (key, value) in Environment.parameters {
            "<tr><td>\(key)</td><td>\(value)</td></tr>"
        }
        """
        </table>
        <h2>Configuration</h2>
        \(app.configuration)
        \(json)
        </body?
        """
    }
}
