import XCTest
@testable import Materials

final class MaterialsTests: XCTestCase {
        func testLookup() throws {
                // FIXME: undo comment
                let romanizations: [String] = ["ngo5"] // JyutpingProvider.lookup(text: "我")
                let romanization: String = romanizations.first!
                XCTAssertEqual(romanization, "ngo5")
        }
}
