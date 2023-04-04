import XCTest
@testable import CoreIME

final class CoreIMETests: XCTestCase {

        // MARK: - Segmentor

        /*
        func testSegment() throws {
                let sourceText: String = "neihou"
                let expected: [[String]] = [["nei", "hou"], ["nei", "ho"], ["nei"], ["ne"]]
                let result = Segmentor.segment(sourceText)
                XCTAssertEqual(result, expected)
        }
        func testScheme() throws {
                let sourceText: String = "neihou"
                let result = Segmentor.scheme(of: sourceText)
                XCTAssertEqual(result, ["nei", "hou"])
        }
        */


        // MARK: - Reverse Lookup

        func testPinyinSegmentor() throws {
                let text: String = "putonghuapinyin"
                let schemes: [[String]] = PinyinSegmentor.segment(text: text)
                if let syllables = schemes.first {
                        XCTAssertEqual(syllables, ["pu", "tong", "hua", "pin", "yin"])
                } else {
                        XCTFail("No schemes")
                }
        }

        /*
        func testPinyinLookup() throws {
                Engine.prepare()
                let result: String = Engine.pinyinLookup(for: "wo").first!.text
                XCTAssertEqual(result, "我")
        }

        func testCangjie() throws {
                Engine.prepare()
                let result: String = Engine.cangjieLookup(for: "dam").first!.text
                XCTAssertEqual(result, "查")
        }
        func testStroke() throws {
                Engine.prepare()
                let result: String = Engine.strokeLookup(for: "wsad").first!.text
                XCTAssertEqual(result, "木")
        }

        func testLeungFan() {
                Engine.prepare()
                let result: String = Engine.leungFanLookup(for: "mukdaan").first!.text
                XCTAssertEqual(result, "查")
        }
        */


        // MARK: - Emoji

        /*
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
        */
}

