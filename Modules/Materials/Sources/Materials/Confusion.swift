import Foundation

public struct ConfusionEntry: Codable {
        public let simplified: String
        public let traditional: [ConfusionTraditional]
}
public struct ConfusionTraditional: Codable {
        public let character: String
        public let romanization: String
        public let note: String
}
public struct Confusion {
        private typealias Entries = [ConfusionEntry]
        public static func fetch() -> [ConfusionEntry] {
                guard let url = Bundle.module.url(forResource: "confusion", withExtension: "json") else { return [] }
                guard let data = try? Data(contentsOf: url) else { return [] }
                guard let confusion = try? JSONDecoder().decode(Entries.self, from: data) else { return [] }
                return confusion
        }
}
