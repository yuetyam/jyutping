import Foundation

struct Hant2Hans {
        static func generate() -> [(traditional: UInt32, simplified: UInt32)] {
                guard let sourceUrl: URL = Bundle.module.url(forResource: "t2s", withExtension: "txt") else { fatalError("Can find file t2s.txt") }
                guard let sourceContent: String = try? String(contentsOf: sourceUrl, encoding: .utf8) else { fatalError("Can not read t2s.txt") }
                let sourceLines: [String] = sourceContent
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .filter({ !$0.isEmpty })
                        .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                        .filter({ !($0.isEmpty || $0.hasPrefix("#")) })
                        .uniqued()
                let entries = sourceLines.map { line -> (traditional: UInt32, simplified: UInt32) in
                        let parts = line.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                        guard parts.count == 2 else { fatalError("Bad format in t2s.txt: \(line)") }
                        let traditional = parts[0]
                        let simplified = parts[1]
                        guard (traditional.count == 1) && (simplified.count == 1) && (traditional != simplified) else { fatalError("Bad format in t2s.txt: \(line)") }
                        guard let traditionalCode = traditional.first?.unicodeScalars.first?.value else { fatalError("Bad code in t2s.txt: \(line)") }
                        guard let simplifiedCode = simplified.first?.unicodeScalars.first?.value else { fatalError("Bad code in t2s.txt: \(line)") }
                        return (traditionalCode, simplifiedCode)
                }
                return entries.sorted(by: { $0.traditional < $1.traditional })
        }
}
