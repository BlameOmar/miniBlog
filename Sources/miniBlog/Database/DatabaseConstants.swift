import FluentKit
import FluentPostgresDriver

enum TableName: String {
    case user
    case password
    case password_login_credential
    case journal_entry
}

extension TableName {
    var string: String { self.rawValue }
}

// Fields

extension FieldProperty {
    convenience init(field: StandardFields) {
        self.init(key: field.key)
    }
}

extension TimestampProperty where Format == DefaultTimestampFormat {
    convenience init(field: StandardFields, on trigger: TimestampTrigger) {
        self.init(key: field.key, on: trigger)
    }
}

enum StandardFields: FieldKey {
    case body
    case created_at
    case email_address
    case hash
    case id
    case name
    case password_hash
    case published_at
    case title
    case updated_at
    case username
}

extension StandardFields {
    var key: FieldKey { self.rawValue }
    var string: String { self.key.description }

    static func foreignID(for tableName: TableName) -> FieldKey {
        .prefix(.string("\(tableName.string)_"), id.key)
    }

    static func qualifiedForeignID(_ tableName: TableName, _ foreignTable: TableName) -> SQLQueryString {
        "\(ident: tableName.string).\(ident: foreignID(for: foreignTable).description)"
    }

    static func qualifiedFieldName(_ tableName: TableName, _ fieldName: StandardFields) -> SQLQueryString {
        "\(ident: tableName.string).\(ident: fieldName.string)"
    }
}

extension DatabaseSchema.FieldDefinition {
    static let id: DatabaseSchema.FieldDefinition =
        .definition(
            name: .key(.id),
            dataType: .uuid,
            constraints: [
                .identifier(auto: false)
            ])

    static let createdAt: DatabaseSchema.FieldDefinition = .definition(
        name: .key(StandardFields.created_at.key),
        dataType: .datetime,
        constraints: [
            .required
        ])

    static let updatedAt: DatabaseSchema.FieldDefinition =
        .definition(
            name: .key(StandardFields.updated_at.key),
            dataType: .datetime,
            constraints: [
                .required
            ])

    static let publishedAt: DatabaseSchema.FieldDefinition =
        .definition(
            name: .key(StandardFields.published_at.key),
            dataType: .datetime,
            constraints: []
        )

    static func foreignID(for tableName: TableName) -> DatabaseSchema.FieldDefinition {
        .definition(
            name: .key(StandardFields.foreignID(for: tableName)),
            dataType: .uuid,
            constraints: [
                .foreignKey(tableName.string, .key(.id), onDelete: .cascade, onUpdate: .cascade)
            ])
    }
}
