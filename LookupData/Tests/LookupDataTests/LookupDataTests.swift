import XCTest
@testable import LookupData

final class LookupDataTests: XCTestCase {
        func testLookup() throws {
                let search: [String] = LookupData.search(for: "我")
                let lookup: String = search.first!
                XCTAssertEqual(lookup, "ngo5")
        }
}
