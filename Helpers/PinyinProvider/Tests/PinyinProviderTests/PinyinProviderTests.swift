import XCTest
@testable import PinyinProvider

final class PinyinProviderTests: XCTestCase {
        func testSplitter() {
                let text: String = "putonghuapinyin"
                let schemes: [[String]] = Splitter.split(text)
                let syllables: [String] = schemes.first ?? []
                XCTAssertEqual(syllables, ["pu", "tong", "hua", "pin", "yin"])
        }

        let provider = PinyinProvider()
        deinit {
                provider.close()
        }

        func testSuggestion() {
                let candidates: [PinyinProvider.PinyinCandidate] = provider.suggest(for: "biang")
                let first = candidates.first!
                XCTAssertEqual(first.text, "𰻞")
        }
        func testLookup() {
                let candidates: [PinyinProvider.JyutpingCandidate] = provider.search(for: "wo")
                let first = candidates.first!
                XCTAssertEqual(first.text, "我")
                XCTAssertEqual(first.jyutping, "ngo5")
        }
}
