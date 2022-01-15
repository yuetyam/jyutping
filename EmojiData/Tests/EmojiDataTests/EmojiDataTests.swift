import XCTest
@testable import EmojiData

final class EmojiDataTests: XCTestCase {
        func testEmojis() throws {
                let emojis: [[String]] = EmojiData.fetchAll()
                XCTAssertEqual(emojis.count, 8)
                XCTAssertEqual(emojis[0].count, 461)
                XCTAssertEqual(emojis[1].count, 199)
                XCTAssertEqual(emojis[2].count, 123)
                XCTAssertEqual(emojis[3].count, 117)
                XCTAssertEqual(emojis[4].count, 128)
                XCTAssertEqual(emojis[5].count, 217)
                XCTAssertEqual(emojis[6].count, 292)
                XCTAssertEqual(emojis[7].count, 259)
                XCTAssertNotEqual(emojis[0][0], "?")
        }
}
