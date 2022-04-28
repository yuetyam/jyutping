import XCTest
@testable import InputMethodData

final class InputMethodDataTests: XCTestCase {

        // MARK: - Pinyin

        func testPinyinSplitter() throws {
                let text: String = "putonghuapinyin"
                let schemes: [[String]] = PinyinSplitter.split(text)
                let syllables: [String] = schemes.first!
                XCTAssertEqual(syllables, ["pu", "tong", "hua", "pin", "yin"])
        }
        func testPinyinProvider() throws {
                let provider = PinyinProvider()
                let candidates = provider.search(for: "wo")
                provider.close()
                let first = candidates.first!
                XCTAssertEqual(first.text, "我")
        }


        // MARK: - ShapeData

        private lazy var shape = ShapeData()
        deinit {
                shape.close()
        }

        func testCangjie() throws {
                let matches = shape.search(cangjie: "dam")
                let first = matches.first!
                XCTAssertEqual(first.text, "查")
        }
        func testStroke() throws {
                let matches = shape.search(stroke: "wsad")
                let first = matches.first!
                XCTAssertEqual(first.text, "木")
        }
        func testStrokeCount() throws {
                let strokes: Int = shape.strokes(of: "木")
                XCTAssertEqual(strokes, 4)
        }


        // MARK: - Loengfan

        func testLoengfan() {
                let provider = LoengfanProvider()
                let candidates = provider.search(for: "mukdaan")
                provider.close()
                let first = candidates.first!
                XCTAssertEqual(first.text, "查")
        }


        // MARK: - Lookup
        func testLookup() throws {
                let search: [String] = Lookup.look(for: "我")
                let first: String = search.first!
                XCTAssertEqual(first, "ngo5")
        }
}
