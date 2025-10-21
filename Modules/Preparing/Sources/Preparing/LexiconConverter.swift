import Foundation
import CommonExtensions

struct LexiconConverter {

        /// Convert jyutping.txt to lexicon entries
        static func jyutping() -> [LexiconEntry] {
                guard let url = Bundle.module.url(forResource: "jyutping", withExtension: "txt") else { fatalError("jyutping.txt not found") }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { fatalError("Failed to read jyutping.txt") }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                return sourceLines.map(convert(_:))
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
                return sourceLines.map(convert(_:))
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
                guard syllableText.isNotEmpty else { fatalError(errorMessage) }
                let anchorText = String(anchors)
                guard let anchorCode: Int = anchorText.charCode else { fatalError(errorMessage) }
                let pingCode = syllableText.hashCode()
                guard let tenKeyAnchorCode: Int = anchorText.tenKeyCharCode else { fatalError(errorMessage) }
                let tenKeyCode: Int = syllableText.tenKeyCharCode ?? 0
                return LexiconEntry(word: word, romanization: romanization, anchors: anchorCode, ping: pingCode, tenKeyAnchors: tenKeyAnchorCode, tenKeyCode: tenKeyCode)
        }
}
