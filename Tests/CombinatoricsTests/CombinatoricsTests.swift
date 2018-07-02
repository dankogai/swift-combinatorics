import XCTest
@testable import Combinatorics

final class CombinatoricsTests: XCTestCase {
    func testBasic() {
        XCTAssertEqual(Combinatorics.factorial(10), 3628800)
    }
    static var allTests = [
        ("testBasic", testBasic),
    ]
}
