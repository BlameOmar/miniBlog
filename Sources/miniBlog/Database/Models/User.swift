import Fluent
import Vapor

final class User: Model, Content {
    static let schema = TableName.user.string

    @ID(custom: .id, generatedBy: .user)
    var id: UUID?

    @Field(field: StandardFields.name)
    var name: String

    @Field(field: StandardFields.email_address)
    @CaseInsensitiveText
    var email: String

    @Field(field: StandardFields.username)
    @CaseInsensitiveText
    var username: String

    @Timestamp(field: .created_at, on: .create)
    var createdAt: Date?

    @Timestamp(field: .updated_at, on: .update)
    var updatedAt: Date?

    @OptionalChild(for: \.$user)
    var password: Password?

    required init() {}

    init(id: UUID, username: String, name: String, email: String) {
        self.id = id
        self.$username.value = CaseInsensitiveText(username)
        self.name = name
        self.$email.value = CaseInsensitiveText(email)
    }

    static func find(username: String, on database: Database) async throws -> User? {
        // swiftlint:disable:next first_where
        try await query(on: database).filter(\.$username == CaseInsensitiveText(username)).first()
    }
}

extension User: ModelSessionAuthenticatable {}

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
