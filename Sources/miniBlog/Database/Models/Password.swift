import Fluent
import Vapor

final class Password: Model {
    static let schema = TableName.password.string

    @ID(custom: .id, generatedBy: .user)
    var id: UUID?

    @Parent(key: StandardFields.foreignID(for: TableName.user))
    var user: User

    @Field(field: .hash)
    var hash: PasswordHash

    @Timestamp(field: .created_at, on: .create)
    var createdAt: Date?

    @Timestamp(field: .updated_at, on: .update)
    var updatedAt: Date?

    required init() {}

    init(id: UUID, user: User, password: Secret<String>) throws {
        self.id = id
        $user.id = try user.requireID()
        hash = try .recommended(password)
    }

    func set(_ password: Secret<String>) throws {
        hash = try .recommended(password)
    }

    func matches(_ password: Secret<String>) -> Bool {
        (try? hash.matches(password)) ?? false
    }
}
