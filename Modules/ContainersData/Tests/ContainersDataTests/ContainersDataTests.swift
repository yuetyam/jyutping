import XCTest
@testable import ContainersData

final class Tests: XCTestCase {
        func testLookup() throws {
                let search: [String] = Lookup.look(for: "我")
                let lookup: String = search.first!
                XCTAssertEqual(lookup, "ngo5")
        }
}
