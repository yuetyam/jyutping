import Foundation

struct LexiconEntry: Hashable {
        let word: String
        let romanization: String
        let anchors: Int
        let ping: Int
        let tenKeyAnchors: Int
        let tenKeyCode: Int
}

struct Jyutping2Lexicon {

        static func convert() -> [LexiconEntry] {
                guard let url = Bundle.module.url(forResource: "jyutping", withExtension: "txt") else { fatalError("jyutping.txt not found") }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { fatalError("Failed to read jyutping.txt") }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap({ generateEntry(from: $0) })
                return entries
        }

        private static func generateEntry(from text: String) -> LexiconEntry? {
                let text = text.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters)
                let parts = text.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                guard parts.count == 2 else { fatalError("bad line format: \(text)") }
                let word: String = parts[0]
                let romanization: String = parts[1]
                let anchors = romanization.split(separator: " ").compactMap(\.first)
                guard !(anchors.isEmpty) else { fatalError("bad line format: \(text)") }
                let syllableText = romanization.filter({ $0.isASCII && $0.isLetter })
                guard !(syllableText.isEmpty) else { fatalError("bad line format: \(text)") }
                let anchorText = String(anchors)
                guard let anchorCode: Int = anchorText.charcode else { fatalError("bad line format: \(text)") }
                let ping: Int = syllableText.hash
                guard let tenKeyAnchorCode: Int = anchorText.tenKeyCharcode else { fatalError("bad line format: \(text)") }
                let tenKeyCode: Int = syllableText.tenKeyCharcode ?? 0
                let entry: LexiconEntry = LexiconEntry(word: word, romanization: romanization, anchors: anchorCode, ping: ping, tenKeyAnchors: tenKeyAnchorCode, tenKeyCode: tenKeyCode)
                return entry
        }
}

struct TextMarkLexicon: Hashable {
        let text: String
        let ping: Int
        let tenKeyCode: Int
        static func convert() -> [TextMarkLexicon] {
                guard let url = Bundle.module.url(forResource: "mark", withExtension: "yaml") else { return [] }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { return [] }
                let sourceLines: [String] = sourceContent
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .map({ $0.trimmingCharacters(in: .whitespaces) })
                        .filter({ !($0.isEmpty || $0.hasPrefix("#")) })
                let entries = sourceLines.compactMap { line -> TextMarkLexicon? in
                        let parts = line.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces) })
                        guard parts.count >= 2 else { return nil }
                        let token = parts[0]
                        let text = parts[1]
                        let ping = token.hash
                        let tenKeyCode = token.tenKeyCharcode ?? 0
                        return TextMarkLexicon(text: text, ping: ping, tenKeyCode: tenKeyCode)
                }
                return entries
        }
}
