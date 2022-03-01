import XCTest
@testable import CharacterSets

final class CharacterSetsTests: XCTestCase {

        func testHongKongVariant() throws {
                let origin: String = "僞臺戶"
                let expected: String = "偽台户"
                let converted: String = Converter.convert(origin, to: .hongkong)
                XCTAssertEqual(converted, expected)
        }

        func testTaiwanVariant() throws {
                let origin: String = "僞啓羣"
                let expected: String = "偽啟群"
                let converted: String = Converter.convert(origin, to: .taiwan)
                XCTAssertEqual(converted, expected)
        }

        func testSimplifier() throws {
                let origin: String = "瞭望瞭解東風"
                let expected: String = "瞭望了解东风"
                let simplifier: Simplifier = Simplifier()
                let converted: String = simplifier.convert(origin)
                XCTAssertEqual(converted, expected)
        }
}
