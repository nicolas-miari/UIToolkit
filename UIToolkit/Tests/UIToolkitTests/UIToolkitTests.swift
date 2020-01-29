import XCTest
@testable import UIToolkit

final class UIToolkitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UIToolkit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
