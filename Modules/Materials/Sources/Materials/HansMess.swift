import Foundation

public struct HansMess: Hashable {

        public struct TraditionalUnit: Hashable {
                public let text: String
                public let note: String
        }

        public let simplified: String
        public let traditional: TraditionalUnit
        public let altTraditional: TraditionalUnit

        public static func fetch() -> [HansMess] {
                guard let url = Bundle.module.url(forResource: "HansMess", withExtension: "txt") else { return [] }
                guard let content: String = try? String(contentsOf: url) else { return [] }
                let sourceLines: [String] = content
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .map({ $0.trimmingCharacters(in: .whitespaces) })
                        .filter({ !$0.isEmpty })
                let entries = sourceLines.map({ line -> HansMess? in
                        let parts = line.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces) })
                        guard parts.count == 3 else { return nil }
                        let simplified = parts[0]
                        let traditionalParts = parts[1].split(separator: "|").map({ $0.trimmingCharacters(in: .whitespaces) })
                        let altTraditionalParts = parts[2].split(separator: "|").map({ $0.trimmingCharacters(in: .whitespaces) })
                        guard traditionalParts.count == 2 && altTraditionalParts.count == 2 else { return nil }
                        let traditional = HansMess.TraditionalUnit(text: traditionalParts[0], note: traditionalParts[1])
                        let altTraditional = HansMess.TraditionalUnit(text: altTraditionalParts[0], note: altTraditionalParts[1])
                        return HansMess(simplified: simplified, traditional: traditional, altTraditional: altTraditional)
                })
                return entries.compactMap({ $0 })
        }
}
