import XCTest
@testable import remote_image

final class remote_imageTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(remote_image().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
