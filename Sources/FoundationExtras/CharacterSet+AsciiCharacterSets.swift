import Foundation

extension CharacterSet {
    /// A set containing all the ASCII characters (U+0000–U+007F).
    public static let asciiCharacters =
        CharacterSet(charactersIn: UnicodeScalar(0)...UnicodeScalar(127))

    /// A set containing non-ASCII unicode characters (U+0080 and above).
    public static let nonAsciiCharacters = asciiCharacters.inverted

    /// A set containing the ASCII digits (0–9).
    public static let asciiDigits = CharacterSet(charactersIn: "0"..."9")

    /// A set containing the ASCII uppercase letters (A–Z).
    public static let asciiUppercaseLetters = CharacterSet(charactersIn: "A"..."Z")

    /// A set containing the ASCII lowercase letters (a–z).
    public static let asciiLowercaseLetters = CharacterSet(charactersIn: "a"..."z")

    /// A set containing the ASCII letters (A–Z and a–z).
    public static let asciiLetters = asciiUppercaseLetters | asciiLowercaseLetters

    /// A set containing the alphanumeric ASCII characters (A–Z, a–z, 0–9).
    public static let asciiAlphanumerics = asciiLetters | asciiDigits
}
