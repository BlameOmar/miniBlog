import SafeHTML

struct LoginView: AuthAwareView {
    let authenticatedUser: User?
    let errorMessage: String?
    let blogConfiguration: BlogConfiguration

    @HTMLBuilder var body: HTMLSafeString {
        DefaultPageTemplate(title: "Auth Debug", authenticatedUser: authenticatedUser, blogConfiguration: blogConfiguration) {
            if let errorMessage = errorMessage {
                "<strong>\(errorMessage)</strong>"
            }
            """
            <form action="/auth/login" method="post">
              <p>
                <label for="username">Username</label><br>
                <input type="text" id="username" name="username" autocomplete="username" spellcheck="false" required>
              </p>
              <p>
                <label for="password">Password</label><br>
                <input type="password" id="password" name="password" autocomplete="current-password" required>
              </p>
              <p><input type="submit" value="Login"></p>
            </form>
            """
        }
    }
}
