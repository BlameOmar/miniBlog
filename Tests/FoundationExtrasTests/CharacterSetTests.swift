import Foundation
import XCTest

@testable import FoundationExtras

final class CharacterSetTests: XCTestCase {
    func testContainsCharacter() {
        let character: Character = "A"
        XCTAssert(CharacterSet.uppercaseLetters.contains(character))
        XCTAssert(!CharacterSet.lowercaseLetters.contains(character))
    }
    
    func testContainsCharactersInString() {
        let string = "Hello, world"
        XCTAssert(CharacterSet.asciiCharacters.contains(charactersIn: string))
        XCTAssert(!CharacterSet.asciiLetters.contains(charactersIn: string))
    }
    
    func testStringContainsOnly() {
        let string = "Hello, world"
        XCTAssert(string.containsOnly(charactersIn: CharacterSet.asciiCharacters))
        XCTAssert(!string.containsOnly(charactersIn: CharacterSet.asciiLetters))
    }
    
    func testCharacterIsContained() {
        let character: Character = "A"
        XCTAssert(character.isContained(in: CharacterSet.uppercaseLetters))
        XCTAssert(!character.isContained(in: CharacterSet.lowercaseLetters))
    }
}
