import Foundation
import CommonExtensions

public struct Metro {

        public struct Station: Sendable {
                public let lineName: String
                public let name: String
                public let romanization: String
        }

        public struct Line: Sendable {
                init(name: String, stations: [Metro.Station]) {
                        self.name = name
                        self.stations = stations
                        self.longest = stations.sorted(by: { ($0.name.count + $0.romanization.count) > ($1.name.count + $1.romanization.count) }).first
                }
                /// Line name
                public let name: String
                public let stations: [Station]
                /// Longest (name.count + romanization.count)
                public let longest: Station?
        }

        public static let cantonMetroLines: [Line] = fetch("CantonMetro")
        public static let fatshanMetroLines: [Line] = fetch("FatshanMetro")
        public static let macauMetroLines: [Line] = fetch("MacauMetro")
        public static let tungkunRailTransitLines: [Line] = fetch("TungkunRailTransit")
        public static let shamchunMetroLines: [Line] = fetch("ShamChunMetro")
        public static let hongkongMTRLines: [Line] = fetch("HongKongMTR")

        private static func fetch(_ name: String) -> [Line] {
                guard let url = Bundle.module.url(forResource: name, withExtension: "yaml") else { return [] }
                guard let content: String = try? String(contentsOf: url) else { return [] }
                let blocks: [String] = content
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .split(separator: "#")
                        .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                let lines = blocks.compactMap { block -> Line? in
                        let texts: [String] = block
                                .components(separatedBy: .newlines)
                                .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                .filter(\.isNotEmpty)
                                .uniqued()
                        guard let lineName: String = texts.first else { return nil }
                        let stations = texts.dropFirst().compactMap { text -> Station? in
                                let parts = text.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                guard let name = parts.first, let romanization = parts.last else { return nil }
                                return Station(lineName: lineName, name: name, romanization: romanization)
                        }
                        return Line(name: lineName, stations: stations)
                }
                return lines
        }
}
