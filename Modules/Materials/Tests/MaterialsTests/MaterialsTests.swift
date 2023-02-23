import XCTest
@testable import Materials

final class MaterialsTests: XCTestCase {
        func testLookup() throws {
                let romanizations: [String] = JyutpingProvider.lookup(text: "我")
                let romanization: String = romanizations.first!
                XCTAssertEqual(romanization, "ngo5")
        }
}
