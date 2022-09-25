import Foundation
import Vapor

struct CMSJournalController {
    func notImplemented(request: Request) async throws -> Response {
        throw Abort(.notImplemented)
    }
}

extension CMSJournalController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: notImplemented)  // eg. GET /cms/journal

        routes.get(":id", use: notImplemented)  // eg. GET /cms/journal/42

        // Forms
        routes.get("new", use: notImplemented)  // eg. GET /cms/journal/new
        routes.get(":id", "edit", use: notImplemented)  // eg. GET /cms/journal/42/edit

        // Modification
        routes.post(":id", use: notImplemented)  // eg. POST /cms/journal/42
        routes.put(":id", use: notImplemented)  // eg. PUT /cms/journal/42 (RESTful API)
        routes.patch(":id", use: notImplemented)  // eg. PUT /cms/journal/42 (RESTful API)

        // Delete journal entries
        routes.delete(":id", use: notImplemented)  // eg. DELETE /cms/journal/42 (RESTful API)
        routes.post(":id", "delete", use: notImplemented)  // eg. POST /cms/journal/42/delete

        // Publish journal entries
        routes.post(":id", "publish", use: notImplemented)  // eg. POST /cms/journal/42/publish
    }
}
