import Fluent
import Foundation

final class PasswordLoginCredentials: Model {
    typealias IDValue = UUID
    static let schema = TableName.password_login_credential.string

    @ID(custom: .id, generatedBy: .user)
    var id: UUID?

    @Field(key: StandardFields.foreignID(for: TableName.user))
    var userID: UUID

    @Field(field: StandardFields.id)
    var passwordID: UUID

    @Field(field: StandardFields.username)
    @CaseInsensitiveText
    var username: String

    @Field(field: StandardFields.password_hash)
    var passwordHash: PasswordHash

    static func find(username: String, on database: Database) async throws -> PasswordLoginCredentials? {
        // TODO: Use type system to avoid use of `.custom`
        // swiftlint:disable:next first_where
        try await query(on: database).filter(\.$username == CaseInsensitiveText(username)).first()
    }
}
