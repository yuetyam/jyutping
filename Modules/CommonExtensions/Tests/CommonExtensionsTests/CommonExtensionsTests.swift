import Testing
import XCTest
@testable import CommonExtensions

@Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
}

final class CommonExtensionsTests: XCTestCase {

        // MARK: - Array extensions

        func testSequenceElementUniqueness() throws {
                let list: [Int] = [0, 1, 3, 4, 3, 2, 1, 1]
                let expected: [Int] = [0, 1, 3, 4, 2]
                XCTAssertEqual(list.distinct(), expected)
        }
        func testArrayFetch() throws {
                let list: [Int] = [0, 1, 2, 3]
                let fetched: [Int?] = [list.fetch(2), list.fetch(5)]
                let expected: [Int?] = [2, nil]
                XCTAssertEqual(fetched, expected)
        }


        // MARK: - Character extensions

        func testCharacterCodePoints() throws {
                let expected: [String] = ["U+65", "U+301"]
                let char: Character = "é"
                XCTAssertEqual(char.codePoints, expected)
        }
        func testCharacterCodePointsText() throws {
                let expected: String = "U+65 U+301"
                let char: Character = "é"
                XCTAssertEqual(char.codePointsText, expected)
        }
        func testCharacterCodePointInitializer() throws {
                let expected: Character = "𥄫"
                let codePoint: String = "U+2512B"
                let found: Character = Character(codePoint: codePoint)!
                XCTAssertEqual(found, expected)
        }
        func testCharacterDecimalCode() throws {
                let expected: Int = 151851
                let char: Character = "𥄫"
                let found: Int = char.decimalCode!
                XCTAssertEqual(found, expected)
        }
        func testCharacterDecimalInitializer() throws {
                let expected: Character = "𥄫"
                let decimal: Int = 151851
                let found: Character = Character(decimal: decimal)!
                XCTAssertEqual(found, expected)
        }
}
