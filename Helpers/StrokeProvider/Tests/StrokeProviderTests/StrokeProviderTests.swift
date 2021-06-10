import XCTest
@testable import StrokeProvider

final class StrokeProviderTests: XCTestCase {

        private let provider = StrokeProvider()
        deinit {
                provider.close()
        }
        func testCangjie() throws {
                let matches: [StrokeProvider.StrokeCandidate] = provider.matchCangjie(for: "dam")
                let first: StrokeProvider.StrokeCandidate = matches.first!
                XCTAssertEqual(first.text, "查")
        }
        func testStroke() throws {
                let matches: [StrokeProvider.StrokeCandidate] = provider.matchStroke(for: "wspd")
                let first: StrokeProvider.StrokeCandidate = matches.first!
                XCTAssertEqual(first.text, "木")
        }
}
