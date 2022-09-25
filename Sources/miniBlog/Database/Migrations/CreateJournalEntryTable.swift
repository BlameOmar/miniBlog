import Fluent
import PostgresKit
import SQLKit

struct CreateJournalEntryTable: AsyncMigration {
    let name: String = "createTable.journal_entry"

    let tableName = TableName.journal_entry

    func prepare(on database: Database) async throws {
        try await database.schema(tableName)
            .field(.id)
            .field(.foreignID(for: TableName.user))
            .field(.name, .string, .required)
            .field(.title, .string, .required)
            .field(.body, .string, .required)
            .field(.createdAt)
            .field(.updatedAt)
            .field(.publishedAt)
            .create()

        try await database.createIndex(on: .published_at, tableName: tableName)
    }

    func revert(on database: Database) async throws {
        try await database.schema(tableName).delete()
    }
}

extension Database {
    func createIndex(on field: StandardFields, tableName: TableName) async throws {
        guard let postgres = self as? PostgresDatabase else {
            throw MigrationError.unsupportedDatabaseError
        }

        try await postgres.sql().create(index: "idx:\(tableName).\(field)").on(tableName.string).column("\(field)")
            .run()
    }
}
