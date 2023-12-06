import Foundation

public struct LineUnit: Hashable {
        public let text: String
        public let romanization: String
}

/// 百家姓
public struct BaakGaaSing: Hashable {
        public static func fetch() -> [LineUnit] {
                guard let url = Bundle.module.url(forResource: "surnames", withExtension: "txt") else { return [] }
                guard let content: String = try? String(contentsOf: url) else { return [] }
                let sourceLines: [String] = content
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .map({ $0.trimmingCharacters(in: .whitespaces) })
                        .filter({ !$0.isEmpty })
                let entries = sourceLines.map { line -> LineUnit? in
                        let parts = line.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces) })
                        guard parts.count == 2 else { return nil }
                        return LineUnit(text: parts.first!, romanization: parts.last!)
                }
                return entries.compactMap({ $0 })
        }
}
