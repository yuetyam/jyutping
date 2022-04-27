import XCTest
@testable import CommonExtensions

final class CommonExtensionsTests: XCTestCase {

        func testArrayUniqued() throws {
                let list: [Int] = [0, 1, 3, 4, 3, 2, 1, 1]
                let expected: [Int] = [0, 1, 3, 4, 2]
                XCTAssertEqual(list.uniqued(), expected)
        }
        func testArrayFetch() throws {
                let list: [Int] = [0, 1, 2, 3]
                let fetched: [Int?] = [list.fetch(2), list.fetch(5)]
                let expected: [Int?] = [2, nil]
                XCTAssertEqual(fetched, expected)
        }
}
