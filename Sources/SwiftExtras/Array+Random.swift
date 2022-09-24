extension Array where Element: FixedWidthInteger {
    public static func random(count: Int) -> Self {
        var generator = SystemRandomNumberGenerator()
        return random(count: count, using: &generator)
    }

    public static func random<T: RandomNumberGenerator>(count: Int, using generator: inout T) -> Self {
        .init(unsafeUninitializedCapacity: count) { buffer, initializedCount in
            for i in 0..<buffer.count {
                buffer[i] = Element.random(in: Element.min...Element.max, using: &generator)
            }
            initializedCount = buffer.count
        }
    }
}
