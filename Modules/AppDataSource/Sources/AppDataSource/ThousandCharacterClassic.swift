import Foundation

/// 千字文
public struct ThousandCharacterClassic: Hashable {
        public static func fetch() -> [TextRomanization] {
                guard let url = Bundle.module.url(forResource: "char1000", withExtension: "txt") else { return [] }
                guard let content: String = try? String(contentsOf: url) else { return [] }
                let sourceLines: [String] = content
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .map({ $0.trimmingCharacters(in: .whitespaces) })
                        .filter(\.isNotEmpty)
                let entries = sourceLines.compactMap { line -> TextRomanization? in
                        let parts = line.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces) })
                        guard parts.count == 2 else { return nil }
                        return TextRomanization(text: parts.first!, romanization: parts.last!)
                }
                return entries
        }
}
