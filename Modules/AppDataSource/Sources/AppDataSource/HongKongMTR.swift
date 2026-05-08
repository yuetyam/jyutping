import Foundation
import CommonExtensions

public struct HongKongMTR {
        public struct Station: Sendable {
                public let name: String
                public let romanization: String
                public let code: String
                public let english: String
                public let background: UInt32
                public let foreground: UInt32
        }
        public struct Line: Sendable {
                public let name: String
                public let code: String
                public let english: String
                public let color: UInt32
                public let stations: [Station]
        }
}

extension HongKongMTR {
        public static let lines : [Line] = {
                guard let url = Bundle.module.url(forResource: "HongKongMTR", withExtension: "yaml") else { return [] }
                guard let content: String = try? String(contentsOf: url) else { return [] }
                let blocks: [String] = content
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .split(separator: "##")
                        .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
                        .filter(\.isNotEmpty)
                return blocks.compactMap({ block -> Line? in
                        let texts: [String] = block
                                .components(separatedBy: .newlines)
                                .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                .filter(\.isNotEmpty)
                                .distinct()
                        let lineName = texts.first ?? "?"
                        let stations = texts.dropFirst().compactMap({ text -> Station? in
                                let parts = text.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                                guard let name = parts.fetch(0), let romanization = parts.fetch(1) else { return nil }
                                let code: String = parts.fetch(2)?.replacingOccurrences(of: "#", with: "", options: .anchored).trimmingCharacters(in: .whitespaces) ?? "?"
                                let english: String = parts.fetch(3) ?? "?"
                                let back: UInt32 = {
                                        guard let value = parts.fetch(4)?.replacingOccurrences(of: "0x", with: "", options: .anchored) else { return 0 }
                                        return UInt32(value, radix: 16) ?? 0
                                }()
                                let fore: UInt32 = {
                                        guard let value = parts.fetch(5)?.replacingOccurrences(of: "0x", with: "", options: .anchored) else { return 0 }
                                        return UInt32(value, radix: 16) ?? 0
                                }()
                                return Station(name: name, romanization: romanization, code: code, english: english, background: back, foreground: fore)
                        })
                        return Line(name: lineName,
                                    code: Line.codeMap[lineName] ?? "?",
                                    english: Line.englishMap[lineName] ?? "?",
                                    color: Line.colorMap[lineName] ?? 0,
                                    stations: stations)
                })
        }()
}

private extension HongKongMTR.Line {
        static let englishMap: [String : String] = [
                "東鐵綫"  : "East Rail Line",
                "觀塘綫"  : "Kwun Tong Line",
                "荃灣綫"  : "Tsuen Wan Line",
                "港島綫"  : "Island Line",
                "東涌綫"  : "Tung Chung Line",
                "將軍澳綫" : "Tseung Kwan O Line",
                "屯馬綫"  : "Tuen Ma Line",
                "迪士尼綫" : "Disneyland Resort Line",
                "南港島綫" : "South Island Line",
                "機場快綫" : "Airport Express",
        ]
        static let codeMap: [String : String] = [
                "東鐵綫"  : "EAL",
                "觀塘綫"  : "KTL",
                "荃灣綫"  : "TWL",
                "港島綫"  : "ISL",
                "東涌綫"  : "TCL",
                "將軍澳綫" : "TKL",
                "屯馬綫"  : "TML",
                "迪士尼綫" : "DRL",
                "南港島綫" : "SIL",
                "機場快綫" : "AEL",
        ]
        static let colorMap: [String : UInt32] = [
                "東鐵綫"  : 0x53b7e8,
                "觀塘綫"  : 0x1a9431,
                "荃灣綫"  : 0xff0000,
                "港島綫"  : 0x0860a8,
                "東涌綫"  : 0xfe7f1d,
                "將軍澳綫" : 0x6b208b,
                "屯馬綫"  : 0x9a3b26,
                "迪士尼綫" : 0xf550a6,
                "南港島綫" : 0xb5bd00,
                "機場快綫" : 0x1c7670,
        ]
}
