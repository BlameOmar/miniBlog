import Collections
import XCTest

@testable import SafeHTML

final class HTMLBuilderTests: XCTestCase {
    struct View {
        let title: String?
        let inventory: OrderedDictionary<String, Int> = [
            "apple": 10,
            "banana": 1,
        ]

        init(title: String? = nil) {
            self.title = title
        }

        @HTMLBuilder var body: HTMLSafeString {
            let indentStyle = HTMLSafeString.IndentStyle.spaces(count: 2)
            """
            <!doctype html>
            <html lang="en-US">
              <head>
            """
            if let title = title {
                .init(indenting: "<title>\(title)</title>", times: 2, style: indentStyle)
            }
            """
              </head>
              <body>
                <table>
            """
            for (item, count) in inventory {
                if count == 1 {
                    .init(indenting: "<tr><td>\(item):</td><td>\(count)</td><tr>", times: 3, style: indentStyle)
                } else {
                    .init(indenting: "<tr><td>\(item)s:</td><td>\(count)</td><tr>", times: 3, style: indentStyle)
                }
            }
            """
                </table>
              </body>
            </html>
            """
        }
    }

    func testBuilder() {
        do {
            let expectedHTML =
                """
                <!doctype html>
                <html lang="en-US">
                  <head>
                  </head>
                  <body>
                    <table>
                      <tr><td>apples:</td><td>10</td><tr>
                      <tr><td>banana:</td><td>1</td><tr>
                    </table>
                  </body>
                </html>
                """
            XCTAssertEqual(String(View().body), expectedHTML)
        }
        do {
            let expectedHTML =
                """
                <!doctype html>
                <html lang="en-US">
                  <head>
                    <title>For sale</title>
                  </head>
                  <body>
                    <table>
                      <tr><td>apples:</td><td>10</td><tr>
                      <tr><td>banana:</td><td>1</td><tr>
                    </table>
                  </body>
                </html>
                """
            XCTAssertEqual(String(View(title: "For sale").body), expectedHTML)
        }
    }
}
