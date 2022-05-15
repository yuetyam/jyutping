import XCTest
@testable import CoreIME

final class CoreIMETests: XCTestCase {

        // MARK: - Splitter

        func testCanSplit() throws {
                let sourceText: String = "neihou"
                let result = Splitter.canSplit(sourceText)
                XCTAssertEqual(result, true)
        }
        func testPeekSplit() throws {
                let sourceText: String = "neihou"
                let result = Splitter.peekSplit(sourceText)
                XCTAssertEqual(result, ["nei", "hou"])
        }
        func testSplit() throws {
                let sourceText: String = "neihou"
                let result = Splitter.split(sourceText).first!
                XCTAssertEqual(result, ["nei", "hou"])
        }
}
