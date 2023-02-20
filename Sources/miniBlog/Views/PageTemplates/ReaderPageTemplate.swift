import SafeHTML

struct ReaderPageTemplate: HTMLView {
    let blogConfiguration: BlogConfiguration
    var blogName: String { blogConfiguration.name}
    let title: String
    let content: () -> HTMLSafeString

    init(title: String, blogConfiguration: BlogConfiguration, @HTMLBuilder content: @escaping () -> HTMLSafeString) {
        self.content = content
        self.title = title
        self.blogConfiguration = blogConfiguration
    }

    @HTMLBuilder var body: HTMLSafeString {
        """
        <!doctype html>
        <html lang="en-US">
          <head>
            <link rel="preload" href="/static/stylesheets/default-styles.css" as="style">
            <link rel="preload" href="/static/fonts/SourceSansVariable-Roman.ttf.woff2" as="font" crossorigin>
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
            </footer>
          </div></body>
        </html>
        """
    }
}
