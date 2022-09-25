import PostgresNIO

@propertyWrapper
struct CaseInsensitiveText {
    var wrappedValue: String

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }
}

extension CaseInsensitiveText {
    init(_ string: String) {
        wrappedValue = string
    }
}

extension CaseInsensitiveText: Codable {
    func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }

    init(from decoder: Decoder) throws {
        self.wrappedValue = try String(from: decoder)
    }
}

extension CaseInsensitiveText: PostgresDataConvertible {
    static var citextDataType: PostgresDataType? = nil

    static var postgresDataType: PostgresDataType {
        guard let value = citextDataType else {
            fatalError("citext datatype not initialized")
        }
        return value
    }

    init?(postgresData: PostgresData) {
        guard let string = postgresData.string else {
            return nil
        }
        wrappedValue = string
    }

    var postgresData: PostgresData? {
        var buffer = ByteBufferAllocator().buffer(capacity: wrappedValue.utf8.count)
        buffer.writeString(wrappedValue)
        return PostgresData(type: CaseInsensitiveText.postgresDataType, formatCode: .binary, value: buffer)
    }
}

extension CaseInsensitiveText {
    static func loadTypeInformation(from database: PostgresDatabase) async throws {
        try await database.sql().select().column("oid").from("pg_type").where("typname", .equal, "citext").limit(1).run
        {
            row in
            guard let oid: Int = try? row.decode(column: "oid") else {
                fatalError("Could not load type information for 'citext'")
            }

            citextDataType = PostgresDataType(UInt32(oid))
        }
    }
}
