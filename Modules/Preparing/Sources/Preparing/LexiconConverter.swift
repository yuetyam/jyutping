import Foundation
import CommonExtensions

struct LexiconConverter {

        /// Source lines read from jyutping.txt
        static let jyutpingSourceLines: [String] = {
                guard let url = Bundle.module.url(forResource: "jyutping", withExtension: "txt") else { fatalError("jyutping.txt not found") }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { fatalError("Failed to read jyutping.txt") }
                return sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        }()
        static func prepareJyutpingSourceLines() {
                if jyutpingSourceLines.isEmpty {
                        print("jyutpingSourceLines is empty")
                }
        }

        /// Convert jyutping.txt to lexicon entries
        static func jyutping() -> [LexiconEntry] {
                return jyutpingSourceLines.map(convert(_:))
        }

        /// Convert pinyin.txt to lexicon entries
        static func pinyin() -> [LexiconEntry] {
                guard let url = Bundle.module.url(forResource: "pinyin", withExtension: "txt") else { fatalError("pinyin.txt not found") }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { fatalError("Failed to read pinyin.txt") }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                return sourceLines.map(convert(_:))
        }

        /// Convert structure.txt to lexicon entries
        static func structure() -> [LexiconEntry] {
                guard let url = Bundle.module.url(forResource: "structure", withExtension: "txt") else { fatalError("structure.txt not found") }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { fatalError("Failed to read structure.txt") }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let transformedLines = sourceLines.map({ line -> String in
                        let parts = line.split(separator: "\t")
                        return parts[0] + "\t" + parts[2]
                })
                return transformedLines.distinct().map(convert(_:))
        }

        private static func convert(_ text: String) -> LexiconEntry {
                let errorMessage: String = "LexiconConverter : BadLineFormat : " + text
                let text = text.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters)
                let parts = text.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                guard parts.count == 2 else { fatalError(errorMessage) }
                let word: String = parts[0]
                let romanization: String = parts[1]
                let anchors = romanization.split(separator: Character.space).compactMap(\.first)
                guard anchors.isNotEmpty else { fatalError(errorMessage) }
                let syllableText = romanization.filter(\.isLowercaseBasicLatinLetter)
                let complex = syllableText.count
                guard complex > 0 else { fatalError(errorMessage) }
                let anchorCode: Int = anchors.serialCode
                let spellCode = syllableText.serialCode
                let nineKeyAnchorsCode: Int = anchors.keypadCode
                let nineKeyCode: Int = syllableText.keypadCode
                return LexiconEntry(word: word, romanization: romanization, complex: complex, anchors: anchorCode, spell: spellCode, nineKeyAnchors: nineKeyAnchorsCode, nineKeyCode: nineKeyCode)
        }
}
