import Foundation
import CommonExtensions

struct TextMarkLexicon: Hashable {

        let input: String
        let mark: String
        let complex: Int
        let spellCode: Int
        let nineKeyCode: Int

        static func == (lhs: TextMarkLexicon, rhs: TextMarkLexicon) -> Bool {
                return lhs.input == rhs.input && lhs.mark == rhs.mark
        }

        func hash(into hasher: inout Hasher) {
                hasher.combine(input)
                hasher.combine(mark)
        }

        static func convert() -> [TextMarkLexicon] {
                guard let url = Bundle.module.url(forResource: "mark", withExtension: "txt") else { return [] }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { return [] }
                let sourceLines: [String] = sourceContent
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .map({ $0.trimmingCharacters(in: .whitespaces) })
                        .filter({ !($0.isEmpty || $0.hasPrefix("#")) })
                        .distinct()
                let entries = sourceLines.compactMap { line -> TextMarkLexicon? in
                        let parts = line.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces) })
                        guard parts.count >= 2 else { return nil }
                        let input = parts[0]
                        let mark = parts[1]
                        let complex = input.count
                        let spellCode = input.serialCode
                        let nineKeyCode = input.keypadCode
                        return TextMarkLexicon(input: input, mark: mark, complex: complex, spellCode: spellCode, nineKeyCode: nineKeyCode)
                }
                return entries.distinct()
        }
}
