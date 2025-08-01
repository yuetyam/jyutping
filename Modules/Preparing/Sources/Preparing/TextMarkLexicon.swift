import Foundation

struct TextMarkLexicon: Hashable {
        let text: String
        let pingCode: Int
        let charCode: Int
        let tenKeyCharCode: Int
        static func convert() -> [TextMarkLexicon] {
                guard let url = Bundle.module.url(forResource: "mark", withExtension: "txt") else { return [] }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { return [] }
                let sourceLines: [String] = sourceContent
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .map({ $0.trimmingCharacters(in: .whitespaces) })
                        .filter({ !($0.isEmpty || $0.hasPrefix("#")) })
                        .uniqued()
                let entries = sourceLines.compactMap { line -> TextMarkLexicon? in
                        let parts = line.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces) })
                        guard parts.count >= 2 else { return nil }
                        let input = parts[0]
                        let text = parts[1]
                        let pingCode = input.hash
                        let charCode: Int = input.charCode ?? 0
                        let tenKeyCharCode: Int = input.tenKeyCharCode ?? 0
                        return TextMarkLexicon(text: text, pingCode: pingCode, charCode: charCode, tenKeyCharCode: tenKeyCharCode)
                }
                return entries
        }
}
