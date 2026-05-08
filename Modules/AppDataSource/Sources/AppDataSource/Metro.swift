import Foundation
import CommonExtensions

public struct Metro {

        public struct Station: Sendable {
                init(label: String, name: String, romanization: String) {
                        self.label = label
                        self.name = name
                        self.romanization = romanization
                }
                public let label: String
                public let name: String
                public let romanization: String
        }

        public struct Line: Sendable {
                init(group: String, indicator: String? = nil, tailLabel: String? = nil, name: String, stations: [Metro.Station]) {
                        let nameComponents = name.split(separator: String.space)
                        self.group = group
                        self.indicator = {
                                if let indicator {
                                        return indicator
                                } else if nameComponents.count > 1 {
                                        return String(nameComponents.first!)
                                } else if let firstChar = name.first {
                                        return String(firstChar)
                                } else {
                                        return name
                                }
                        }()
                        self.tailLabel = {
                                if let tailLabel {
                                        return tailLabel
                                } else if nameComponents.count > 1 {
                                        return String(nameComponents.last!)
                                } else {
                                        return name
                                }
                        }()
                        self.name = name
                        self.stations = stations
                }
                public let group: String
                public let indicator: String
                public let tailLabel: String
                public let name: String
                public let stations: [Station]
        }

        public static let cantonMetroLines: [Line] = fetch("CantonMetro")
        public static let fatshanMetroLines: [Line] = fetch("FatshanMetro")
        public static let macauMetroLines: [Line] = fetch("MacauMetro")
        public static let tungkunRailTransitLines: [Line] = fetch("TungkunRailTransit")
        public static let shamchunMetroLines: [Line] = fetch("ShamChunMetro")

        private static func fetch(_ name: String) -> [Line] {
                guard let url = Bundle.module.url(forResource: name, withExtension: "yaml") else { return [] }
                guard let content: String = try? String(contentsOf: url) else { return [] }
                let blocks: [String] = content
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .split(separator: "##")
                        .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                        .filter(\.isNotEmpty)
                let lines = blocks.compactMap { block -> Line? in
                        let texts: [String] = block
                                .components(separatedBy: .newlines)
                                .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                .filter(\.isNotEmpty)
                                .distinct()
                        guard let lineNameText: String = texts.first else { return nil }
                        let lineNameComponents = lineNameText.split(separator: String.tab)
                        let lineName: String = String(lineNameComponents.last ?? "??")
                        let indicator: String? = {
                                guard lineNameComponents.count > 1 else { return nil }
                                if let firstComponent = lineNameComponents.first {
                                        return String(firstComponent)
                                } else {
                                        return nil
                                }
                        }()
                        let tailLabel: String? = {
                                guard lineNameComponents.count > 1 else { return nil }
                                if let tail = lineNameComponents.fetch(1) {
                                        return String(tail)
                                } else {
                                        return nil
                                }
                        }()
                        let stations = texts.dropFirst().compactMap { text -> Station? in
                                let parts = text.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                guard let name = parts.fetch(0), let romanization = parts.fetch(1) else { return nil }
                                let label: String = parts.fetch(2)?.replacingOccurrences(of: "#", with: "").trimmingCharacters(in: .whitespaces) ?? "?"
                                return Station(label: label, name: name, romanization: romanization)
                        }
                        return Line(group: name, indicator: indicator, tailLabel: tailLabel, name: lineName, stations: stations)
                }
                return lines
        }
}
