import Foundation
import CommonExtensions

public struct Lyrics {
        public static func fetchLokYuDaai() -> [TextRomanization] {
                return fetch(name: "Lyrics.LokYuDaai")
        }
        public static func fetchYuetGwongGwong() -> [TextRomanization] {
                return fetch(name: "Lyrics.YuetGwongGwong")
        }
        public static func fetchSinFaMunYuetLau() -> [TextRomanization] {
                return fetch(name: "Lyrics.SinFaMunYuetLau")
        }
        private static func fetch(name: String) -> [TextRomanization] {
                guard let url = Bundle.module.url(forResource: name, withExtension: "txt") else { return [] }
                guard let content: String = try? String(contentsOf: url) else { return [] }
                let sourceLines: [String] = content
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .map({ $0.trimmingCharacters(in: .whitespaces) })
                        .filter(\.isNotEmpty)
                return sourceLines.compactMap({ line -> TextRomanization? in
                        let parts = line.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces) })
                        guard parts.count == 2 else { return nil }
                        return TextRomanization(text: parts.first!, romanization: parts.last!)
                })
        }
}
