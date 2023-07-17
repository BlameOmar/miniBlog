import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("users")
        usersRoutes.get(use: list)
        usersRoutes.post(use: create)
        usersRoutes.group(":username") { userRoutes in
            userRoutes.get(use: get)
        }
    }

    func list(request: Request) async throws -> [User] {
        try await User.query(on: request.db).all()
    }

    func create(request: Request) async throws -> User {
        let user = try request.content.decode(User.self)
        try await user.save(on: request.db)
        return user
    }

    func get(request: Request) async throws -> User {
        let username = try request.parameters.require("username")
        guard let user = try await User.find(username: username, on: request.db) else {
            throw Abort(.notFound)
        }

        // Found a case-insensitive match
        if user.username != username {
            throw Abort.redirect(to: "/users/\(user.username)", redirectType: .permanent)
        }

        return user
    }
}
