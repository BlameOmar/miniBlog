import PostgresNIO

@propertyWrapper
struct CaseInsensitiveText {
    var wrappedValue: String
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

extension CaseInsensitiveText {
    static var postgresDataType: PostgresDataType!
}

extension CaseInsensitiveText {
    static func loadTypeInformation(from database: PostgresDatabase) async throws {
        try await database.sql().select().column("oid").from("pg_type").where("typname", .equal, "citext").limit(1).run
        {
            row in
            guard let oid: PostgresOID = try? row.decode(column: "oid") else {
                fatalError("Could not load type information for 'citext'")
            }

            postgresDataType = PostgresDataType(UInt32(oid.value))
        }
    }
}

extension CaseInsensitiveText: PostgresCodable {
    init<JSONDecoder>(
        from byteBuffer: inout NIOCore.ByteBuffer,
        type: PostgresNIO.PostgresDataType,
        format: PostgresNIO.PostgresFormat,
        context: PostgresNIO.PostgresDecodingContext<JSONDecoder>
    ) throws where JSONDecoder: PostgresNIO.PostgresJSONDecoder {
        guard format == .binary && type == Self.psqlType else {
            throw PostgresDecodingError.Code.typeMismatch
        }
        guard let value = byteBuffer.readString(length: byteBuffer.readableBytes) else {
            throw PostgresDecodingError.Code.failure
        }
        self.init(value)
    }

    static var psqlType: PostgresNIO.PostgresDataType {
        Self.postgresDataType
    }

    static var psqlFormat: PostgresNIO.PostgresFormat {
        .text
    }

    func encode<JSONEncoder>(
        into byteBuffer: inout NIOCore.ByteBuffer,
        context: PostgresNIO.PostgresEncodingContext<JSONEncoder>
    ) throws where JSONEncoder: PostgresNIO.PostgresJSONEncoder {
        byteBuffer.writeString(self.wrappedValue)
    }
}
