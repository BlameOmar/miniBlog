import Foundation

extension Character {
    /// Determines whether the character is a member of a set.
    public func isContained(in characterSet: CharacterSet) -> Bool {
        characterSet.contains(self)
    }
}
