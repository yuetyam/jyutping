import Foundation

struct Jyutping2Lexicon {

        static func convert() -> [String] {
                guard let url = Bundle.module.url(forResource: "jyutping", withExtension: "txt") else { return [] }
                guard let sourceContent = try? String(contentsOf: url) else { return [] }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap({ generateEntry(from: $0) })
                return entries
        }

        private static func generateEntry(from text: String) -> String? {
                let text = text.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters)
                let parts = text.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                guard parts.count == 2 else { return nil }
                let word: String = parts[0]
                let romanization: String = parts[1]
                guard let shortcut: Int = shortcutCode(of: romanization) else { return nil }
                guard let ping: Int = pingCode(of: romanization) else { return nil }
                let entry: String = "\(word)\t\(romanization)\t\(shortcut)\t\(ping)"
                return entry
        }

        private static func shortcutCode(of text: String) -> Int? {
                let syllables = text.split(separator: " ").map({ $0.trimmingCharacters(in: .controlCharacters) })
                let anchors = syllables.compactMap(\.first)
                let anchorText = String(anchors)
                guard !(anchorText.isEmpty) else { return nil }
                return anchorText.charcode
        }

        private static func pingCode(of text: String) -> Int? {
                let filtered = text.filter({ !(spaceAndTones.contains($0)) })
                guard !(filtered.isEmpty) else { return nil }
                return filtered.hash
        }

        private static let spaceAndTones: Set<Character> = Set("123 456")
}

struct TextMarkLexicon {
        static func convert() -> [String] {
                guard let url = Bundle.module.url(forResource: "mark", withExtension: "yaml") else { return [] }
                guard let sourceContent = try? String(contentsOf: url) else { return [] }
                let sourceLines: [String] = sourceContent
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .map({ $0.trimmingCharacters(in: .whitespaces) })
                        .filter({ !($0.isEmpty || $0.hasPrefix("#")) })
                let entries = sourceLines.compactMap { line -> String? in
                        let parts = line.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces) })
                        guard parts.count >= 2 else { return nil }
                        let token = parts[0]
                        let text = parts[1]
                        let code = token.hash
                        return "\(code)\t\(text)"
                }
                return entries
        }
}
