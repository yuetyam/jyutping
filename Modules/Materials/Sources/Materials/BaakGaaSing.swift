import Foundation

public struct BaakGaaSing: Hashable {

        public struct SurnameUnit: Hashable {
                public let text: String
                public let romanization: String
        }

        public static func fetch() -> [SurnameUnit] {
                guard let url = Bundle.module.url(forResource: "surnames", withExtension: "txt") else { return [] }
                guard let content: String = try? String(contentsOf: url) else { return [] }
                let sourceLines: [String] = content
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .map({ $0.trimmingCharacters(in: .whitespaces) })
                        .filter({ !$0.isEmpty })
                let entries = sourceLines.map { line -> SurnameUnit? in
                        let parts = line.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces) })
                        guard parts.count == 2 else { return nil }
                        return SurnameUnit(text: parts.first!, romanization: parts.last!)
                }
                return entries.compactMap({ $0 })
        }
}
