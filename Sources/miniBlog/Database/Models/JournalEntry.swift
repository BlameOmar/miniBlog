import Fluent
import Vapor

final class JournalEntry: Model, Content {
    static let schema = TableName.journal_entry.string

    @ID(custom: .id, generatedBy: .user)
    var id: UUID?

    @Parent(key: StandardFields.foreignID(for: TableName.user))
    var author: User

    @Field(field: .name)
    var name: String

    @Field(field: .title)
    var title: String

    @Field(field: .body)
    var body: String

    @Timestamp(field: .created_at, on: .create)
    var createdAt: Date?

    @Timestamp(field: .updated_at, on: .update)
    var updatedAt: Date?

    @Timestamp(field: .published_at, on: .none)
    var publishedAt: Date?

    required init() {}

    convenience init(id: UUID, author: User, title: String, body: String) {
        self.init(id: id, author: author, name: JournalEntry.generateName(from: title), title: title, body: body)
    }

    init(id: UUID, author: User, name: String, title: String, body: String) {
        self.id = id
        self.name = name
        self.author = author
        self.title = title
        self.body = body
    }

    static func generateName(from title: String) -> String {
        title.lowercased().replacingOccurrences(of: #"\s+"#, with: "-", options: [.regularExpression])
    }

    static func find(name: String, dateRange: Range<Date>? = nil, on database: Database) async throws -> JournalEntry? {
        if let dateRange = dateRange {
            database.logger.info("daterange: \(dateRange)")
        }
        // swiftlint:disable:next first_where
        return try await query(on: database).filter(\.$name == name).filter(\.$publishedAt != nil).sort(
            \.$publishedAt, .descending
        ).first()
    }

    static func find(resolving idOrName: String, on database: Database) async throws -> JournalEntry? {
        if let id = UUID(idOrName) {
            return try await JournalEntry.find(id, on: database)
        }

        let name = idOrName
        return try await JournalEntry.find(name: name, on: database)
    }
}
