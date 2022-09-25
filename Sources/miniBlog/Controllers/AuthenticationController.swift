import Vapor

struct AuthenticationController: RouteCollection {
    private static let timeWastingPasswordHash = try! PasswordHash.recommended("correct-horse-battery-staple")

    func boot(routes: RoutesBuilder) throws {
        routes.get("login", use: getLogin)
        routes.post("login", use: login)
        routes.post("logout", use: logout)
    }

    func getLogin(request: Request) async throws -> LoginView {
        LoginView(authenticatedUser: request.auth.get(), errorMessage: nil)
    }

    struct LoginRequest: Content {
        let username: String
        let password: Secret<String>
    }

    func login(request: Request) async throws -> Response {
        let loginRequest = try request.content.decode(LoginRequest.self)
        let wrongPasswordMessage = "Wrong password."

        guard let credentials = try await PasswordLoginCredentials.find(username: loginRequest.username, on: request.db)
        else {
            // Frustrate timing attacks by matching against a password hash even if no matching user is found.

            _ = try? AuthenticationController.timeWastingPasswordHash.matches(loginRequest.password)
            let view = LoginView(authenticatedUser: nil, errorMessage: wrongPasswordMessage)
            return try await view.encodeResponse(status: .unauthorized, for: request)
        }

        guard try credentials.passwordHash.matches(loginRequest.password) else {
            let view = LoginView(authenticatedUser: nil, errorMessage: wrongPasswordMessage)
            return try await view.encodeResponse(status: .unauthorized, for: request)
        }

        guard let user = try await User.find(credentials.userID, on: request.db) else {
            let view = LoginView(authenticatedUser: nil, errorMessage: wrongPasswordMessage)
            return try await view.encodeResponse(status: .unauthorized, for: request)
        }

        request.auth.login(user)
        return request.redirect(to: "/")
    }

    func logout(request: Request) async throws -> Response {
        request.auth.logout(User.self)
        return request.redirect(to: "/")
    }
}

struct SessionAuthenticator: AsyncMiddleware {
    func authenticate(sessionID: User.SessionID, for request: Request) async throws {
        if let user = try await User.find(sessionID, on: request.db) {
            request.auth.login(user)
        }
    }

    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard !request.auth.has(User.self) else {
            request.logger.debug("User already authenticated")
            return try await next.respond(to: request)
        }

        if request.hasSession, let userID = request.session.authenticated(User.self) {
            try await authenticate(sessionID: userID, for: request)
        }

        let response = try await next.respond(to: request)

        if let user = request.auth.get(User.self) {
            request.session.authenticate(user)
        } else if request.hasSession {
            request.session.destroy()
        }

        return response
    }
}
