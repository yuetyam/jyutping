import Foundation

public struct CantonMetro {

        public struct Station {
                public let lineName: String
                public let name: String
                public let romanization: String
        }

        public struct Line {

                init(name: String, stations: [CantonMetro.Station]) {
                        self.name = name
                        self.stations = stations
                        self.longest = stations.sorted(by: { ($0.name.count + $0.romanization.count) > ($1.name.count + $1.romanization.count) }).first
                }

                public let name: String
                public let stations: [Station]
                public let longest: Station?
        }

        public static let lines: [Line] = fetch()

        private static func fetch() -> [Line] {
                guard let path: String = Bundle.module.path(forResource: "CantonMetro", ofType: "yaml") else { return [] }
                guard let content: String = try? String(contentsOfFile: path) else { return [] }
                let blocks: [String] = content
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .split(separator: "#")
                        .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                let lines: [Line?] = blocks.map { block -> Line? in
                        let texts: [String] = block
                                .components(separatedBy: .newlines)
                                .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                .filter({ !$0.isEmpty })
                                .uniqued()
                        guard let lineName: String = texts.first else { return nil }
                        let stations = texts.dropFirst().map { text -> Station? in
                                let parts = text.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                guard let name = parts.first, let romanization = parts.last else { return nil }
                                return Station(lineName: lineName, name: name, romanization: romanization)
                        }
                        let lineStations = stations.compactMap({ $0 })
                        return Line(name: lineName, stations: lineStations)
                }
                return lines.compactMap({ $0 })
        }
}
