import SafeHTML

protocol AuthAwareView: HTMLView {
    var authenticatedUser: User? { get }
}

struct DefaultPageTemplate: AuthAwareView {
    let blogName = "Omar’s Blog"
    let copyrightStatement = "© 2021 Omar Stefan Evans. All rights reserved."
    let title: String
    var authenticatedUser: User?
    let content: () -> HTMLSafeString

    init(title: String, authenticatedUser: User?, @HTMLBuilder content: @escaping () -> HTMLSafeString) {
        self.content = content
        self.title = title
        self.authenticatedUser = authenticatedUser
    }

    @HTMLBuilder var body: HTMLSafeString {
        """
        <!-- \(copyrightStatement) -->
        <!doctype html>
        <html lang="en-US">
          <head>
            <link rel="preload" href="/static/stylesheets/default-styles.css" as="style">
            <link rel="preload" href="/static/fonts/SourceSansVariable-Roman.ttf.woff2" as="font" crossorigin>
            <link rel="stylesheet" href="/static/stylesheets/default-styles.css">
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
        } else {
            #"<p><a href="/auth/login">Login</a></p>"#
        }
        """
              <p>\(copyrightStatement)</p>
            </footer>
          </div></body>
        </html>
        """
    }
}
