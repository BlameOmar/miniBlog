import XCTest

@testable import miniBlog

final class ValidEmailAddressTests: XCTestCase {
    func testCommon() {
        XCTAssertTrue("user@example.com".isValidEmailAddress)
        XCTAssertTrue("user@mail.example.com".isValidEmailAddress)
        XCTAssertTrue("first.last@example.com".isValidEmailAddress)
    }

    func testInternationalized() {
        XCTAssertTrue("Pelé@example.com".isValidEmailAddress)
        XCTAssertTrue("δοκιμή@παράδειγμα.δοκιμή".isValidEmailAddress)
        XCTAssertTrue("我買@屋企.香港".isValidEmailAddress)
        XCTAssertTrue("二ノ宮@黒川.日本".isValidEmailAddress)
        XCTAssertTrue("медведь@с-балалайкой.рф".isValidEmailAddress)
        XCTAssertTrue("संपर्क@डाटामेल.भारत".isValidEmailAddress)
        XCTAssertTrue("👨🏾‍💻@🏠.example".isValidEmailAddress)
    }

    func testUnderscores() {
        XCTAssertTrue("first.separated_last@example.com".isValidEmailAddress)
    }

    func testHyphens() {
        XCTAssertTrue("first.hyphenated-last@example.com".isValidEmailAddress)
        XCTAssertTrue("fully-qualified-domain@example.com".isValidEmailAddress)
        XCTAssertTrue("disposable.style.email.with-symbol@example.com".isValidEmailAddress)
    }

    func testPlusSigns() {
        XCTAssertTrue("disposable.style.email.with+symbol@example.com".isValidEmailAddress)
        XCTAssertTrue("user.name+tag+sorting@example.com".isValidEmailAddress)
    }

    func testShortLocalPart() {
        XCTAssertTrue("u@example.com".isValidEmailAddress)
    }

    func testTopLevelDomain() {
        XCTAssertTrue("user@example".isValidEmailAddress)
    }

    func testSpecialCharacters() {
        XCTAssertTrue("mailhost!username@example.com".isValidEmailAddress)
        XCTAssertTrue("user%example.com@example.com".isValidEmailAddress)
        XCTAssertTrue("!#$%&'*+-/=?^_`{|}~@example.com".isValidEmailAddress)
    }

    func testLocalPartMaxLength() {
        XCTAssertTrue("\(String(repeating: "x", count: 64))@example.com".isValidEmailAddress)
    }

    func testMaxLengthDNSLabel() {
        XCTAssertTrue("user@\(String(repeating: "x", count: 63)).example".isValidEmailAddress)
    }
}

final class InvalidEmailAddressTests: XCTestCase {
    func testObvious() {
        XCTAssertFalse("First M. Last".isValidEmailAddress)
        XCTAssertFalse("13 Market Street".isValidEmailAddress)
        XCTAssertFalse("+1 212 555 0100".isValidEmailAddress)
        XCTAssertFalse("www.example.com".isValidEmailAddress)
        XCTAssertFalse("too@many@signs@example.com".isValidEmailAddress)
        XCTAssertFalse("".isValidEmailAddress)
        XCTAssertFalse("user@".isValidEmailAddress)
        XCTAssertFalse("@example.com".isValidEmailAddress)
    }

    func testQuotedLocalParts() {
        XCTAssertFalse(#""user"@example.com"#.isValidEmailAddress)
        XCTAssertFalse(#"first."".last@example.com"#.isValidEmailAddress)
        XCTAssertFalse(#""extra@signs"@example.com"#.isValidEmailAddress)
        XCTAssertFalse(#""loading..."@example.com"#.isValidEmailAddress)
    }

    func testIpAddresses() {
        XCTAssertFalse("user@[192.0.2.10]".isValidEmailAddress)
        XCTAssertFalse("user@[IPv6:2001:db8::10]".isValidEmailAddress)
    }

    func testComments() {
        XCTAssertFalse("(comment)user@example.com".isValidEmailAddress)
        XCTAssertFalse("user(comment)@example.com".isValidEmailAddress)
        XCTAssertFalse("user@(comment)example.com".isValidEmailAddress)
        XCTAssertFalse("user@example.com(comment)".isValidEmailAddress)
    }

    func testTrailingDotInDomain() {
        XCTAssertFalse("user@example.com.".isValidEmailAddress)
        XCTAssertFalse("user@mail.example.com.".isValidEmailAddress)
        XCTAssertFalse("first.last@example.com.".isValidEmailAddress)
    }

    func testExceedLocalPartMaxLength() {
        XCTAssertFalse("\(String(repeating: "x", count: 65))@example.com".isValidEmailAddress)
    }

    func testExceedDNSLabelMaxLength() {
        XCTAssertFalse("user@\(String(repeating: "x", count: 64)).example".isValidEmailAddress)
    }

    func testExceedMaxLength() {
        let domainMaxLength = 253
        let addressMaxLength = 254

        let localPartAndAtSign = "user@"
        let maxLengthLabel = String(repeating: "x", count: 63)
        let maxLengthDomain = [String](repeatElement(maxLengthLabel, count: 4)).joined(separator: ".")
            .appending(".example").suffix(domainMaxLength)
        let maxLengthAddress =
            localPartAndAtSign + maxLengthDomain.suffix(addressMaxLength - localPartAndAtSign.utf8.count)
        XCTAssertTrue(maxLengthAddress.isValidEmailAddress)
        XCTAssertFalse("a\(maxLengthAddress)".isValidEmailAddress)
    }

    func testInvalidSyntax() {
        XCTAssertFalse("user.@example.com".isValidEmailAddress)
        XCTAssertFalse(".user@example.com".isValidEmailAddress)
        XCTAssertFalse("first..last@example.com".isValidEmailAddress)
        XCTAssertFalse("user@192.0.2.10".isValidEmailAddress)
        XCTAssertFalse("user@2001:db8::10".isValidEmailAddress)
        XCTAssertFalse(#"a"b(c)d,e:f;g<h>i[j\k]l@example.com"#.isValidEmailAddress)
        XCTAssertFalse(#"just"not"right@example.com"#.isValidEmailAddress)
        XCTAssertFalse(#"this is"not\allowed@example.com"#.isValidEmailAddress)
        XCTAssertFalse(##"this\ still\"not\\allowed@example.com"##.isValidEmailAddress)
    }
}
