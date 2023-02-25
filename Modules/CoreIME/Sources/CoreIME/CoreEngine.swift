import Foundation
import SQLite3

private struct RowCandidate {
        let candidate: Candidate
        let row: Int
        let isExactlyMatch: Bool
}

private extension Array where Element == RowCandidate {
        func sorted() -> [RowCandidate] {
                return self.sorted(by: { (lhs, rhs) -> Bool in
                        let shouldCompare: Bool = !lhs.isExactlyMatch && !rhs.isExactlyMatch
                        guard shouldCompare else { return lhs.isExactlyMatch && !rhs.isExactlyMatch }
                        let lhsTextCount: Int = lhs.candidate.text.count
                        let rhsTextCount: Int = rhs.candidate.text.count
                        guard lhsTextCount >= rhsTextCount else { return false }
                        return (rhs.row - lhs.row) > 50000
                })
        }
}

extension Engine {

        public static func suggest(for text: String, segmentation: Segmentation) -> [Candidate] {
                switch text.count {
                case 0:
                        return []
                case 1:
                        return shortcut(for: text)
                default:
                        return fetch(text: text, segmentation: segmentation)
                }
        }

        private static func fetch(text: String, segmentation: Segmentation) -> [CoreCandidate] {
                let textWithoutSeparators: String = text.filter({ !($0.isSeparator) })
                guard let bestScheme: SyllableScheme = segmentation.first, !bestScheme.isEmpty else {
                        return processVerbatim(textWithoutSeparators)
                }
                let convertedText = textWithoutSeparators.replacingOccurrences(of: "(?<!c|s|j|z)yu(?!k|m|ng)", with: "jyu", options: .regularExpression)
                if bestScheme.length == convertedText.count {
                        return process(text: convertedText, origin: text, sequences: segmentation)
                } else {
                        return processPartial(text: textWithoutSeparators, origin: text, sequences: segmentation)
                }
        }
        private static func processVerbatim(_ text: String) -> [CoreCandidate] {
                let rounds = (0..<text.count).map { number -> [CoreCandidate] in
                        let leading: String = String(text.dropLast(number))
                        return match(for: leading) + shortcut(for: leading)
                }
                return rounds.flatMap({ $0 }).uniqued()
        }
        private static func process(text: String, origin: String, sequences: [[String]]) -> [CoreCandidate] {
                let hasSeparators: Bool = text.count != origin.count
                let candidates = match(schemes: sequences, hasSeparators: hasSeparators, fullTextCount: origin.count)
                guard !hasSeparators else { return candidates }
                let fullProcessed: [CoreCandidate] = match(for: text) + shortcut(for: text)
                let backup: [CoreCandidate] = processVerbatim(text)
                let fallback: [CoreCandidate] = fullProcessed + candidates + backup
                guard let firstCandidate = candidates.first else { return fallback }
                let firstInputCount: Int = firstCandidate.input.count
                guard firstInputCount != text.count else { return fallback }
                let tailText: String = String(text.dropFirst(firstInputCount))
                let tailSegmentation: Segmentation = Segmentor.engineSegment(tailText)
                let hasSchemes: Bool = !(tailSegmentation.first?.isEmpty ?? true)
                guard hasSchemes else { return fallback }
                let tailCandidates = match(schemes: tailSegmentation, hasSeparators: false)
                guard !(tailCandidates.isEmpty) else { return fallback }
                let qualified = candidates.enumerated().filter({ $0.offset < 3 && $0.element.input.count == firstInputCount })
                let combines = tailCandidates.map { tail -> [CoreCandidate] in
                        return qualified.map({ $0.element + tail })
                }
                let concatenated: [CoreCandidate] = combines.flatMap({ $0 }).enumerated().filter({ $0.offset < 4 }).map(\.element)
                return fullProcessed + concatenated + candidates + backup
        }
        private static func processPartial(text: String, origin: String, sequences: [[String]]) -> [CoreCandidate] {
                let hasSeparators: Bool = text.count != origin.count
                let candidates: [CoreCandidate] = match(schemes: sequences, hasSeparators: hasSeparators, fullTextCount: origin.count)
                guard !hasSeparators else { return candidates }
                let fullProcessed: [CoreCandidate] = match(for: text) + shortcut(for: text)
                let backup: [CoreCandidate] = processVerbatim(text)
                let fallback: [CoreCandidate] = fullProcessed + candidates + backup
                guard let firstCandidate: CoreCandidate = candidates.first else { return fallback }
                let firstInputCount: Int = firstCandidate.input.count
                guard firstInputCount != text.count else { return fallback }
                let tailText: String = String(text.dropFirst(firstInputCount))
//                if let tailOne: CoreCandidate = prefix(match: tailText, count: 1).first {
//                        let qualified = candidates.enumerated().filter({ $0.offset < 3 && $0.element.input.count == firstInputCount })
//                        let combines = qualified.map({ $0.element + tailOne })
//                        return fullProcessed + combines + candidates + backup
//                }
                let tailSyllables: [String] = Segmentor.scheme(of: tailText)
                guard !(tailSyllables.isEmpty) else { return fallback }
                var concatenated: [CoreCandidate] = []
                let hasTailCandidate: Bool = false
//                {
//                        let syllablesText = tailSyllables.joined()
//                        let difference: Int = tailText.count - syllablesText.count
//                        guard difference > 1 else { return false }
//                        let syllablesPlusOne = tailText.dropLast(difference - 1)
//                        guard let one = prefix(match: String(syllablesPlusOne), count: 1).first else { return false }
//                        let qualified = candidates.enumerated().filter({ $0.offset < 3 && $0.element.input.count == firstInputCount })
//                        let combines = qualified.map({ $0.element + one })
//                        concatenated = combines
//                        return true
//                }()
                if !hasTailCandidate {
                        for (index, _) in tailSyllables.enumerated().reversed() {
                                let someSyllables: String = tailSyllables[0...index].joined()
                                if let one: CoreCandidate = match(for: someSyllables, limit: 1).first {
                                        let qualified = candidates.enumerated().filter({ $0.offset < 3 && $0.element.input.count == firstInputCount })
                                        let combines = qualified.map({ $0.element + one })
                                        concatenated = combines
                                        break
                                }
                        }
                }
                return fullProcessed + concatenated + candidates + backup
        }
        private static func match(schemes: [[String]], hasSeparators: Bool, fullTextCount: Int = -1) -> [CoreCandidate] {
                let matches = schemes.map { scheme -> [RowCandidate] in
                        let joinedText = scheme.joined()
                        let isExactlyMatch: Bool = joinedText.count == fullTextCount
                        return matchRowCandidate(for: joinedText, isExactlyMatch: isExactlyMatch)
                }
                let candidates: [CoreCandidate] = matches.flatMap({ $0 }).sorted().map(\.candidate)
                guard hasSeparators else { return candidates }
                let firstSyllable: String = schemes.first?.first ?? "X"
                let filtered: [CoreCandidate] = candidates.filter { candidate in
                        let firstRomanization: String = candidate.romanization.components(separatedBy: String.space).first ?? "Y"
                        return firstSyllable == firstRomanization.removedTones()
                }
                return filtered
        }
}

private extension Engine {

        // CREATE TABLE imetable(word TEXT NOT NULL, romanization TEXT NOT NULL, ping INTEGER NOT NULL, shortcut INTEGER NOT NULL, prefix INTEGER NOT NULL);

        static func shortcut(for text: String, count: Int = 100) -> [CoreCandidate] {
                guard !text.isEmpty else { return [] }
                let textHash: Int = text.replacingOccurrences(of: "y", with: "j").hash
                var candidates: [CoreCandidate] = []
                let queryString = "SELECT word, romanization FROM imetable WHERE shortcut = \(textHash) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let candidate = CoreCandidate(text: word, romanization: romanization, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }

        static func match(for text: String, limit: Int? = nil) -> [CoreCandidate] {
                let tones: String = text.tones
                let hasTones: Bool = !tones.isEmpty
                let ping: String = hasTones ? text.removedTones() : text
                guard !(ping.isEmpty) else { return [] }
                let candidates: [CoreCandidate] = {
                        if let limit {
                                return queryPingWithLimit(for: ping, limit: limit)
                        } else {
                                return queryPing(for: ping)
                        }
                }()
                guard hasTones else { return candidates }
                let sameTones = candidates.filter({ $0.romanization.tones == tones })
                guard sameTones.isEmpty else { return sameTones }
                let filtered = candidates.filter({ item -> Bool in
                        let syllables = item.romanization.split(separator: " ")
                        let rawSyllables = item.romanization.removedTones().split(separator: " ")
                        guard rawSyllables.uniqued().count == syllables.count else { return false }
                        let times: Int = syllables.reduce(0, { $0 + (text.contains($1) ? 1 : 0) })
                        return times == tones.count
                })
                return filtered
        }
        private static func queryPing(for text: String) -> [CoreCandidate] {
                var candidates: [CoreCandidate] = []
                let queryString = "SELECT word, romanization FROM imetable WHERE ping = \(text.hash);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let candidate = CoreCandidate(text: word, romanization: romanization, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        private static func queryPingWithLimit(for text: String, limit: Int) -> [CoreCandidate] {
                var candidates: [CoreCandidate] = []
                let queryString = "SELECT word, romanization FROM imetable WHERE ping = \(text.hash) LIMIT \(limit);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let candidate = CoreCandidate(text: word, romanization: romanization, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }

        static func matchRowCandidate(for text: String, isExactlyMatch: Bool) -> [RowCandidate] {
                let tones: String = text.tones
                let hasTones: Bool = !tones.isEmpty
                let ping: String = hasTones ? text.removedTones() : text
                guard !(ping.isEmpty) else { return [] }
                let candidates = queryRowCandidate(for: ping, isExactlyMatch: isExactlyMatch)
                guard hasTones else { return candidates }
                let sameTones = candidates.filter({ $0.candidate.romanization.tones == tones })
                guard sameTones.isEmpty else { return sameTones }
                let filtered = candidates.filter({ item -> Bool in
                        let syllables = item.candidate.romanization.split(separator: " ")
                        let rawSyllables = item.candidate.romanization.removedTones().split(separator: " ")
                        guard rawSyllables.uniqued().count == syllables.count else { return false }
                        let times: Int = syllables.reduce(0, { $0 + (text.contains($1) ? 1 : 0) })
                        return times == tones.count
                })
                return filtered
        }
        private static func queryRowCandidate(for text: String, isExactlyMatch: Bool) -> [RowCandidate] {
                var rowCandidates: [RowCandidate] = []
                let queryString = "SELECT rowid, word, romanization FROM imetable WHERE ping = \(text.hash);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let rowid: Int = Int(sqlite3_column_int64(queryStatement, 0))
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 2))
                                let candidate: CoreCandidate = CoreCandidate(text: word, romanization: romanization, input: text)
                                let rowCandidate: RowCandidate = RowCandidate(candidate: candidate, row: rowid, isExactlyMatch: isExactlyMatch)
                                rowCandidates.append(rowCandidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return rowCandidates
        }
}
