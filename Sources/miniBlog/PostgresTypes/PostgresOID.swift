import PostgresNIO

struct PostgresOID {
    var wrappedValue: Int32
}

extension PostgresOID {
    init(_ value: Int32) {
        self.init(wrappedValue: value)
    }

    var value: Int32 { wrappedValue }
}

extension PostgresOID: Codable {
    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }

    init(from decoder: Decoder) throws {
        try self.init(Int32(from: decoder))
    }
}

extension PostgresOID: PostgresCodable {
    init<JSONDecoder>(
        from byteBuffer: inout NIOCore.ByteBuffer,
        type: PostgresNIO.PostgresDataType,
        format: PostgresNIO.PostgresFormat,
        context: PostgresNIO.PostgresDecodingContext<JSONDecoder>
    ) throws where JSONDecoder: PostgresNIO.PostgresJSONDecoder {
        guard format == .binary && type == .oid else {
            throw PostgresDecodingError.Code.typeMismatch
        }

        guard byteBuffer.readableBytes == 4, let value = byteBuffer.readInteger(as: Int32.self) else {
            throw PostgresDecodingError.Code.failure
        }

        self.init(value)
    }

    static var psqlType: PostgresNIO.PostgresDataType {
        .oid
    }

    static var psqlFormat: PostgresNIO.PostgresFormat {
        .binary
    }

    func encode<JSONEncoder>(
        into byteBuffer: inout NIOCore.ByteBuffer,
        context: PostgresNIO.PostgresEncodingContext<JSONEncoder>
    ) throws where JSONEncoder: PostgresNIO.PostgresJSONEncoder {
        byteBuffer.writeInteger(value, as: Int32.self)
    }
}
