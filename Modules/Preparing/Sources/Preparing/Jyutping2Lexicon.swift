import Foundation

struct Jyutping2Lexicon {

        static func convert() -> [String] {
                guard let url = Bundle.module.url(forResource: "jyutping", withExtension: "txt") else { return [] }
                guard let sourceContent = try? String(contentsOf: url) else { return [] }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.map({ generateEntry(from: $0) })
                return entries.compactMap({ $0 })
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
                guard text.contains(" ") else {
                        guard let first = text.first else { return nil }
                        let anchor: String = String(first)
                        return anchor.hash
                }
                let syllables = text.split(separator: " ").map({ $0.trimmingCharacters(in: .controlCharacters) })
                let anchors = syllables.map({ $0.first }).compactMap({ $0 }).map({ String($0) }).joined()
                guard !(anchors.isEmpty) else { return nil }
                return anchors.hash
        }

        private static func pingCode(of text: String) -> Int? {
                let filtered = text.filter({ !(spaceAndTones.contains($0)) })
                guard !(filtered.isEmpty) else { return nil }
                return filtered.hash
        }

        private static let spaceAndTones: Set<Character> = Set("123 456")
}
