import Foundation

struct Pinyin {
        static func process() -> [LexiconEntry] {
                guard let url = Bundle.module.url(forResource: "pinyin", withExtension: "txt") else { return [] }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { return [] }
                let sourceLines = sourceContent
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .trimmingCharacters(in: .controlCharacters)
                        .components(separatedBy: .newlines)
                        .filter({ !($0.isEmpty) })
                        .uniqued()
                let entries = sourceLines.compactMap { text -> LexiconEntry? in
                        let parts = text.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                        guard parts.count == 2 else { fatalError("bad line format: \(text)") }
                        let word = parts[0]
                        let pinyin = parts[1]
                        let anchors = pinyin.split(separator: " ").compactMap(\.first)
                        guard !(anchors.isEmpty) else { fatalError("bad line format: \(text)") }
                        let syllableText = pinyin.replacingOccurrences(of: " ", with: "")
                        guard !(syllableText.isEmpty) else { fatalError("bad line format: \(text)") }
                        let anchorText = String(anchors)
                        guard let anchorCode: Int = anchorText.charcode else { fatalError("bad line format: \(text)") }
                        let ping = syllableText.hash
                        guard let tenKeyAnchorCode: Int = anchorText.tenKeyCharcode else { fatalError("bad line format: \(text)") }
                        let tenKeyCode: Int = syllableText.tenKeyCharcode ?? 0
                        let entry: LexiconEntry = LexiconEntry(word: word, romanization: pinyin, anchors: anchorCode, ping: ping, tenKeyAnchors: tenKeyAnchorCode, tenKeyCode: tenKeyCode)
                        return entry
                }
                return entries.uniqued()
        }
}
