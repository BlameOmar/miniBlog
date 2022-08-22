extension String {
    init(_ value: StaticString) {
        self = value.withUTF8Buffer { inputBuffer in
            String(unsafeUninitializedCapacity: inputBuffer.count) { buffer in
                _ = buffer.initialize(from: inputBuffer)
                return inputBuffer.count
            }
        }
    }
}
