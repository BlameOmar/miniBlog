import SafeHTML

struct DebugStatusView: HTMLView {
    let app: Blog

    init(app: Blog) {
        self.app = app
    }

    @HTMLBuilder var body: HTMLSafeString {
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
        </body?
        """
    }
}
