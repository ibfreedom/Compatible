import XCTest
@testable import Compatible

final class CompatibleTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Compatible().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
