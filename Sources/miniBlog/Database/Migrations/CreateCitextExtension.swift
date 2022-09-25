import FluentKit
import PostgresKit

struct CreateCitextExtension: AsyncMigration {
    let name: String = "createExtension.citext"

    func prepare(on database: Database) async throws {
        guard let postgres = database as? PostgresDatabase else {
            throw MigrationError.unsupportedDatabaseError
        }
        try await postgres.sql().raw("CREATE EXTENSION IF NOT EXISTS citext").run()
    }

    func revert(on database: Database) async throws {
        guard let postgres = database as? PostgresDatabase else {
            throw MigrationError.unsupportedDatabaseError
        }
        try await postgres.sql().raw("DROP EXTENSION IF EXISTS cixtext").run()
    }
}
