import XCTest
@testable import Simplifier

final class SimplifierTests: XCTestCase {
        func testConverter() throws {
                let originalText: String = "五陵年少金市東銀鞍白馬笑春風"
                let destinationText: String = "五陵年少金市东银鞍白马笑春风"
                let simplifier: Simplifier = Simplifier()
                let convertedText: String = simplifier.convert(originalText)
                XCTAssertEqual(convertedText, destinationText)
        }
}
