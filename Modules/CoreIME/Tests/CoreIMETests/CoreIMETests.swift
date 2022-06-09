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


        // MARK: - Reverse Lookup

        func testPinyinSplitter() throws {
                let text: String = "putonghuapinyin"
                let schemes: [[String]] = PinyinSplitter.split(text)
                let syllables: [String] = schemes.first!
                XCTAssertEqual(syllables, ["pu", "tong", "hua", "pin", "yin"])
        }
        func testPinyinLookup() throws {
                Lychee.prepare()
                let result: String = Lychee.pinyinLookup(for: "wo").first!.text
                XCTAssertEqual(result, "我")
        }

        func testCangjie() throws {
                Lychee.prepare()
                let result: String = Lychee.cangjieLookup(for: "dam").first!.text
                XCTAssertEqual(result, "查")
        }
        func testStroke() throws {
                Lychee.prepare()
                let result: String = Lychee.strokeLookup(for: "wsad").first!.text
                XCTAssertEqual(result, "木")
        }

        func testLeungFan() {
                Lychee.prepare()
                let result: String = Lychee.leungFanLookup(for: "mukdaan").first!.text
                XCTAssertEqual(result, "查")
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

