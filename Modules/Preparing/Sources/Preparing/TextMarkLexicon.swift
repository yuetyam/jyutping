import Foundation

struct TextMarkLexicon: Hashable {
        let text: String
        let ping: Int
        let tenKeyCode: Int
        static func convert() -> [TextMarkLexicon] {
                guard let url = Bundle.module.url(forResource: "mark", withExtension: "txt") else { return [] }
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
                        let pingCode = token.hash
                        let tenKeyCode = token.tenKeyCharCode ?? 0
                        return TextMarkLexicon(text: text, ping: pingCode, tenKeyCode: tenKeyCode)
                }
                return entries
        }
}
