import SafeHTML

@main
struct Run {
    static func main() {
        struct HTML: CustomStringConvertible {
            let title = "Hello!"
            let copyrightStatement = "© 2022 Omar Stefan Evans. All rights reserved."
            let content: HTMLSafeString

            @HTMLBuilder var body: HTMLSafeString {
                """
                <!-- \(copyrightStatement) -->
                <!doctype html>
                <html lang="en-US">
                  <head>
                    <title>\(title)</title>
                  </head>
                  <body>
                    \(content)
                  </body>
                </html>
                """
            }

            var description: String {
                body.description
            }
        }

        let untrustedContent = "<script>alert('hello');</script>"
        print(HTML(content: "<p>Hello world!</p> \(untrustedContent)"))
    }
}
