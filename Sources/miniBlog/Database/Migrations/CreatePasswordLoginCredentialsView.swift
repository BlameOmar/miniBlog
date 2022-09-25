import Fluent
import PostgresKit

struct CreatePasswordLoginCredentialsView: AsyncMigration {
    let name: String = "createView.password_login_credential"

    let tableName = TableName.password_login_credential

    func prepare(on database: Database) async throws {
        guard let postgres = database as? PostgresDatabase else {
            throw MigrationError.unsupportedDatabaseError
        }

        let query: SQLQueryString =
            """
            CREATE  VIEW \(ident: tableName.string) (\(
                idents: [
                    StandardFields.id.string,
                    StandardFields.foreignID(for: TableName.user).description,
                    StandardFields.username.string,
                    StandardFields.password_hash.string,
                ],
                joinedBy: ","
            )) AS
            SELECT
                \(StandardFields.qualifiedFieldName(.password, .id)),
                \(StandardFields.qualifiedFieldName(.user, .id)),
                \(StandardFields.qualifiedFieldName(.user, .username)),
                \(StandardFields.qualifiedFieldName(.password, .hash))
            FROM \(ident: TableName.user.string) INNER JOIN \(ident: TableName.password.string)
            ON \(StandardFields.qualifiedFieldName(.user, .id)) = \(StandardFields.qualifiedForeignID(.password, .user))
            """
        try await postgres.sql().raw(query).run()
    }

    func revert(on database: Database) async throws {
        try await database.schema(tableName).delete()
    }
}
