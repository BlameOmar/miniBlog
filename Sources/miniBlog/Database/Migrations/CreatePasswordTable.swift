import Fluent
import SQLKit

struct CreatePasswordTable: AsyncMigration {
    let name: String = "createTable.password"

    let tableName = TableName.password

    func prepare(on database: Database) async throws {
        try await database.schema(tableName)
            .field(.id)
            .field(.foreignID(for: TableName.user))
            .field(.hash, .string, .required)
            .field(.createdAt)
            .field(.updatedAt)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(tableName).delete()
    }
}
