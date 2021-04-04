import XCTest
@testable import JyutpingProvider

final class JyutpingProviderTests: XCTestCase {
        func testExample() {
                XCTAssertEqual(JyutpingProvider.search(for: "我").first!, "ngo5")
        }
}
