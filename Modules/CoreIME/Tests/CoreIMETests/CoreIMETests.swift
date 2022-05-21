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


        // MARK: - Emoji

        func testEmoji() throws {
                let emojis: [[String]] = EmojiSource.fetchAll()
                XCTAssertEqual(emojis.count, 8)
                XCTAssertEqual(emojis[0].count, 480)
                XCTAssertEqual(emojis[1].count, 204)
                XCTAssertEqual(emojis[2].count, 126)
                XCTAssertEqual(emojis[3].count, 118)
                XCTAssertEqual(emojis[4].count, 131)
                XCTAssertEqual(emojis[5].count, 222)
                XCTAssertEqual(emojis[6].count, 293)
                XCTAssertEqual(emojis[7].count, 259)
                XCTAssertNotEqual(emojis[0][0], "?")
        }

}
