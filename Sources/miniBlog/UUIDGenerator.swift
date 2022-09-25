import Foundation

/// A nonstandard uuid generatorx
///
/// ```
/// 0                               1
/// 0 1 2 3 4 5 6 7 8 9 A B C D E F 0 1 2 3 4 5 6 7 8 9 A B C D E F
/// +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
/// |                         timestamp_ms                          |
/// +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
/// |         timestamp_ms          |        process_random         |
/// +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
/// |    version    |     extra     |            counter            |
/// +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
/// |    counter    |                 random-b                      |
/// +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
/// ```
final class UUIDGenerator {
    static let defaultGenerator: UUIDGenerator = .init()

    private static let version: UInt64 = 1
    private static let versionWidth = 8
    private static let generatorIDBitWidth = 16
    private static let timestampBitWidth = 48
    private static let extraBitWidth = 8
    private static let counterBitWidth = 24
    private static let randomFieldBitWidth = 24

    func next() -> UUID {
        let timestampBits = Clock.milliseconds
        if timestampBits > prevTimestampBits {
            counter.resetWithRandomStartingValue()
        }

        let counterBits: UInt64 = counter.next()
        let uuid = makeUUID(timestampBits: timestampBits, counterBits: counterBits)

        defer {
            prevTimestampBits = timestampBits
        }
        return uuid
    }

    private func makeUUID(timestampBits: UInt64, counterBits: UInt64) -> UUID {
        let extraBits: UInt64 = 0
        let randomBits: UInt64 = .random(in: 0...(1 << Self.randomFieldBitWidth - 1))

        let upperBits = (timestampBits << Self.generatorIDBitWidth | generatorID).bigEndian
        let lowerBits =
            (Self.version << (Self.extraBitWidth + Self.counterBitWidth + Self.randomFieldBitWidth) | extraBits
            << (Self.counterBitWidth + Self.randomFieldBitWidth) | counterBits << Self.randomFieldBitWidth | randomBits)
            .bigEndian

        var uuidBytes = UUID.zero.uuid

        withUnsafeMutableBytes(of: &uuidBytes) { uuidByteBuffer in
            uuidByteBuffer.storeBytes(of: upperBits, toByteOffset: 0, as: UInt64.self)
            uuidByteBuffer.storeBytes(of: lowerBits, toByteOffset: 8, as: UInt64.self)
        }

        return UUID(uuid: uuidBytes)
    }

    fileprivate struct Counter {
        struct Value {
            init(_ value: Int) {
                precondition(Self.range ~= value)
                self.value = value
            }

            static func randomStartingValue() -> Value {
                .init(.random(in: startRange))
            }

            static let bitWidth = UUIDGenerator.counterBitWidth
            static let min = 0
            static let max = (1 << bitWidth) - 1
            static let startMax = max >> 1
            static let range: ClosedRange<Int> = min...max
            static let startRange: ClosedRange<Int> = min...startMax
            static let bitmask = max

            var bits: UInt64 { UInt64(value) }

            private let value: Int
        }

        init(start value: Value) {
            self.value = value
        }

        init() {
            self.init(start: 0)
        }

        static func withRandomStartingValue() -> Counter {
            .init(start: .randomStartingValue())
        }

        mutating func next() -> Value {
            defer { value += 1 }
            return value
        }

        mutating func next() -> UInt64 {
            next().bits
        }

        mutating func resetWithRandomStartingValue() {
            value = .randomStartingValue()
        }

        private var value: Value
    }

    private struct Clock {
        /// A 48-bit unsigned integer representing the number of milliseconds since 2001-01-01 00:00:00 UTC.
        static var milliseconds: UInt64 {
            UInt64(Date().timeIntervalSinceReferenceDate * 1000) & ((1 << UUIDGenerator.timestampBitWidth) - 1)
        }
    }

    private var generatorID = UInt64.random(in: 0...0xFFFF)
    private var counter = Counter.withRandomStartingValue()
    private var prevTimestampBits: UInt64 = 0
}

// MARK: IntIDGenerator.Counter.Value Extensions

extension UUIDGenerator.Counter.Value: Codable {}
extension UUIDGenerator.Counter.Value: Equatable {}
extension UUIDGenerator.Counter.Value: Hashable {}
extension UUIDGenerator.Counter.Value: Comparable {
    fileprivate static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}

extension UUIDGenerator.Counter.Value: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int

    init(integerLiteral value: Int) {
        self.init(value)
    }
}

extension UUIDGenerator.Counter.Value: CustomStringConvertible {
    var description: String {
        String(value, radix: 10, uppercase: false)
    }
}

extension UUIDGenerator.Counter.Value: AdditiveArithmetic {
    fileprivate static func + (lhs: Self, rhs: Self) -> Self {
        .init((lhs.value &+ rhs.value) & Self.bitmask)
    }

    fileprivate static func - (lhs: Self, rhs: Self) -> Self {
        .init((lhs.value &- rhs.value) & Self.bitmask)
    }
}

extension UUID {
    static var zero: UUID {
        .init(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }

    static var min: UUID {
        .zero
    }

    static var max: UUID {
        .init(uuid: (0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF))
    }
}

actor AsyncUUIDGenerator {
    static let defaultGenerator: AsyncUUIDGenerator = .init()

    private let generator = UUIDGenerator()

    func next() -> UUID {
        generator.next()
    }
}

extension UUID {
    static func generate() async -> UUID {
        await AsyncUUIDGenerator.defaultGenerator.next()
    }
}
