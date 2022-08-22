import Foundation

extension StringProtocol {
    /// Determines whether all the string's characters are members of a set.
    public func containsOnly(charactersIn characterSet: CharacterSet) -> Bool {
        characterSet.contains(charactersIn: self)
    }
}
