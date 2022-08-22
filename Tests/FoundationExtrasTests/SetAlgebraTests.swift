import XCTest

@testable import FoundationExtras

final class SetAlgebraOperatorTests: XCTestCase {
    func testIntersectionOperator() {
        let a: Set = ["apple", "banana", "cantaloupe"]
        let b: Set = ["apple", "banana", "durian"]
        let intersection = a & b
        let expected: Set = ["apple", "banana"]
        XCTAssertEqual(intersection, expected)
    }
    func testUnionOperator() {
        let a: Set = ["apple", "banana", "cantaloupe"]
        let b: Set = ["apple", "banana", "durian"]
        let union = a | b
        let expected: Set = ["apple", "banana", "cantaloupe", "durian"]
        XCTAssertEqual(union, expected)
    }

}
