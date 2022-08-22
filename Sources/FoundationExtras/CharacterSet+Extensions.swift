import Foundation

extension CharacterSet {
    /// Determines whether the set contains all a string's characters.
    public func contains<StringType: StringProtocol>(charactersIn string: StringType) -> Bool {
        string.unicodeScalars.allSatisfy { self.contains($0) }
    }

    /// Determines whether the set contains a character.
    public func contains(_ character: Character) -> Bool {
        character.unicodeScalars.allSatisfy { self.contains($0) }
    }
}
