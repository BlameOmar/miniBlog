import SafeHTML

protocol AuthAwareView: HTMLView {
    var authenticatedUser: User? { get }
}

struct DefaultPageTemplate: AuthAwareView {
    var blogName: String { blogConfiguration.name }
    let title: String
    var authenticatedUser: User?
    let content: () -> HTMLSafeString
    let blogConfiguration: BlogConfiguration

    init(title: String, authenticatedUser: User?, blogConfiguration: BlogConfiguration, @HTMLBuilder content: @escaping () -> HTMLSafeString) {
        self.content = content
        self.title = title
        self.authenticatedUser = authenticatedUser
        self.blogConfiguration = blogConfiguration
    }

    @HTMLBuilder var body: HTMLSafeString {
        """
        <!doctype html>
        <html lang="en-US">
          <head>
            <link rel="preload" href="/static/stylesheets/default-styles.css" as="style">
            <link rel="preload" href="/static/fonts/Montserrat.woff2" as="font" crossorigin>
            <link rel="preload" href="/static/fonts/Exo2.woff2" as="font" crossorigin>
            <link rel="stylesheet" href="/static/stylesheets/default-styles.css">
            <script src="/static/javascript/public.js" async></script>
            <title>\(title)</title>
          </head>
          <body><div class="vstack page-content">
            <header class="page-header"><h1>\(blogName)</h1></header>
            <main class="expands">
              \(content())
            </main>
            <footer class="page-footer">
        """
        if let user = authenticatedUser {
            """
            <p>
              You are logged in as \(user.name) <i>(\(user.username))</i>.
              <form action="/auth/logout" method="post"><button>Logout</button></form>
            </p>
            """
        }
        """
            </footer>
          </div></body>
        </html>
        """
    }
}
