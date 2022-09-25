import FluentKit
import FluentPostgresDriver

struct CreateUserTable: AsyncMigration {
    let name: String = "createTable.user"

    func prepare(on database: Database) async throws {
        try await database.schema(TableName.user)
            .field(.id)
            .field(.username, .custom("citext"), .required)
            .field(.name, .string, .required)
            .field(.email_address, .custom("citext"), .required)
            .field(.createdAt)
            .field(.updatedAt)
            .unique(on: .username)
            .unique(on: .email_address)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(TableName.user).delete()
    }
}

extension Database {
    func schema(_ tableName: TableName) -> SchemaBuilder {
        schema(tableName.string)
    }
}

extension SchemaBuilder {
    @discardableResult
    func unique(on fields: StandardFields..., name: String? = nil) -> Self {
        self.constraint(
            .constraint(
                .unique(fields: fields.map { .key($0.key) }),
                name: name
            ))
    }

    @discardableResult
    func field(
        _ field: StandardFields,
        _ dataType: DatabaseSchema.DataType,
        _ constraints: DatabaseSchema.FieldConstraint...
    ) -> Self {
        self.field(
            .definition(
                name: .key(field.key),
                dataType: dataType,
                constraints: constraints
            ))
    }
}
