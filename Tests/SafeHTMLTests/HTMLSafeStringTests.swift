import XCTest

@testable import SafeHTML

final class HTMLSafeStringInitializationTests: XCTestCase {
    func testDefaultIntialization() {
        let html = HTMLSafeString()
        XCTAssertEqual(String(html), "")
    }

    func testInitializationFromStaticString() {
        let html: HTMLSafeString = "<p>Hello</p>"
        XCTAssertEqual(String(html), "<p>Hello</p>")
    }

    func testInitializationFromAnotherHTMLSafeString() {
        let trusted: HTMLSafeString = "<p>Hello</p>"
        let html = HTMLSafeString(trusted)
        XCTAssertEqual(String(html), "<p>Hello</p>")
    }

    func testInitializationWithIndentation() {
        do {
            let original: HTMLSafeString = """
                <div>

                  <p>Hello world</p>

                </div>
                """
            let expected: HTMLSafeString = """
                    <div>

                      <p>Hello world</p>

                    </div>
                """
            let indented = HTMLSafeString(indenting: original, times: 2, style: .spaces(count: 2))
            XCTAssertEqual(indented, expected)
        }
        do {
            let original: HTMLSafeString = """
                <div>

                \t<p>Hello world</p>

                </div>
                """
            let expected: HTMLSafeString = """
                \t\t\t<div>

                \t\t\t\t<p>Hello world</p>

                \t\t\t</div>
                """
            let indented = HTMLSafeString(indenting: original, times: 3, style: .tabs)
            XCTAssertEqual(indented, expected)
        }
    }

    func testInitializationFromInteger() {
        do {
            let html = HTMLSafeString(10)
            XCTAssertEqual(String(html), "10")
        }
        do {
            let html = HTMLSafeString(10, radix: 16, uppercase: true)
            XCTAssertEqual(String(html), "A")
        }
        do {
            let html = HTMLSafeString(10, radix: 16, uppercase: false)
            XCTAssertEqual(String(html), "a")
        }
    }

    func testInitializationFromBinaryFloatingPoint() {
        #if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
        do {
            let value: Float16 = 1.0
            let html = HTMLSafeString(value)
            XCTAssertEqual(String(html), "1.0")
        }
        #endif
        do {
            let value: Float32 = 1.0
            let html = HTMLSafeString(value)
            XCTAssertEqual(String(html), "1.0")
        }
        do {
            let value: Float64 = 1.0
            let html = HTMLSafeString(value)
            XCTAssertEqual(String(html), "1.0")
        }
        do {
            let value: some BinaryFloatingPoint = 1.0
            let html = HTMLSafeString(value)
            XCTAssertEqual(String(html), "1.0")
        }
    }
}

final class HTMLSafeStringInterpolationTests: XCTestCase {
    func testInterpolationWithString() {
        let untrusted: String = "<evil/>"
        let html: HTMLSafeString = "<div>\(untrusted)</div>"
        XCTAssertEqual(String(html), "<div>&lt;evil/&gt;</div>")
    }

    func testInterpolationWithAnotherHTMLSafeString() {
        let trusted: HTMLSafeString = "<b>Hello</b>"
        let html: HTMLSafeString = "<p>\(trusted)</p>"
        XCTAssertEqual(String(html), "<p><b>Hello</b></p>")
    }

    func testInterpolationWithCustomType() {
        struct Foo: CustomStringConvertible {
            var description: String { "<foo/>" }
        }
        let html: HTMLSafeString = "<p>\(Foo())</p>"
        XCTAssertEqual(String(html), "<p>&lt;foo/&gt;</p>")
    }

    func testInterpolationWithInteger() {
        do {
            let html: HTMLSafeString = "<p>Users: \(10)</p>"
            XCTAssertEqual(String(html), "<p>Users: 10</p>")
        }
        do {
            let html: HTMLSafeString = "<p>User ID: \(10, radix: 16, uppercase: true)</p>"
            XCTAssertEqual(String(html), "<p>User ID: A</p>")
        }
        do {
            let html: HTMLSafeString = "<p>User ID: \(10, radix: 16, uppercase: false)</p>"
            XCTAssertEqual(String(html), "<p>User ID: a</p>")
        }
    }

    func testInterpolationFromBinaryFloatingPoint() {
        #if !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
        do {
            let value: Float16 = 89.5
            let html = HTMLSafeString("<p>GPA: \(value)</p>")
            XCTAssertEqual(String(html), "<p>GPA: 89.5</p>")
        }
        #endif
        do {
            let value: Float32 = 89.5
            let html = HTMLSafeString("<p>GPA: \(value)</p>")
            XCTAssertEqual(String(html), "<p>GPA: 89.5</p>")
        }
        do {
            let value: Float64 = 89.5
            let html = HTMLSafeString("<p>GPA: \(value)</p>")
            XCTAssertEqual(String(html), "<p>GPA: 89.5</p>")
        }
        do {
            let value: some BinaryFloatingPoint = 89.5
            let html = HTMLSafeString("<p>GPA: \(value)</p>")
            XCTAssertEqual(String(html), "<p>GPA: 89.5</p>")
        }
    }
}

final class HTMLSageStringOperationsTests: XCTestCase {
    func testAppend() {
        let first: HTMLSafeString = "<p>Hello "
        let second: HTMLSafeString = "world</p>"
        let html = first + second
        XCTAssertEqual(String(html), "<p>Hello world</p>")
    }
    func testJoin() {
        let trustedString: [HTMLSafeString] = ["<li>apple</li>", "<li>banana</li>", "<li>cantaloupe</li>"]
        let html = trustedString.joined(separator: " ")
        XCTAssertEqual(String(html), "<li>apple</li> <li>banana</li> <li>cantaloupe</li>")
    }
}

final class HTMLSafeStringFoundationProtocolsTests: XCTestCase {
    func testEncodable() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let list: [HTMLSafeString] = ["<li>apple</li>", "<li>banana</li>", "<li>cantaloupe</li>"]
        let jsonString = try! String(data: encoder.encode(list), encoding: .utf8)
        XCTAssertEqual(jsonString, #"["<li>apple</li>","<li>banana</li>","<li>cantaloupe</li>"]"#)
    }

    func testCustomStringConvertible() {
        let html: HTMLSafeString = "<p>Hello</p>"
        XCTAssertEqual(html.description, "<p>Hello</p>")
    }

    func testCustomDebugStringConvertible() {
        let html: HTMLSafeString = "<p>Hello</p>"
        XCTAssertEqual(html.debugDescription, #""<p>Hello</p>""#)
    }

    func testTextOutputStreamable() {
        let html: HTMLSafeString = "<p>Hello</p>"
        var output: String = ""
        html.write(to: &output)
        XCTAssertEqual(String(html), output)
    }

    func testComparable() {
        let first: HTMLSafeString = "apple"
        let second: HTMLSafeString = "banana"
        XCTAssertLessThan(first, second)
    }
}
