private let charactersToEscape: [Character] = ["<", ">", "&", "\"", "'"]
private let replacementMap: [Character: String] = [
    "<": "&lt;",
    ">": "&gt;",
    "&": "&amp;",
    "\"": "&quot;",
    "'": "&apos;",
]

extension StringProtocol {
    func escapingXMLNamedEntities() -> String {
        let numCharactersToEscape = self.reduce(0) { partialResult, character in
            charactersToEscape.contains(character) ? partialResult + 1 : partialResult
        }
        var segments = [String]()
        var remaining = Substring(self)
        segments.reserveCapacity(2 * numCharactersToEscape + 1)
        while !remaining.isEmpty {
            guard let index = remaining.firstIndex(where: { charactersToEscape.contains($0) }) else {
                segments.append(String(remaining))
                break
            }
            let unescaped = String(remaining[..<index])
            segments.append(unescaped)

            let replaced = replacementMap[remaining[index]]!
            segments.append(replaced)

            remaining = remaining[index...].dropFirst()
        }
        return segments.joined()
    }
}
