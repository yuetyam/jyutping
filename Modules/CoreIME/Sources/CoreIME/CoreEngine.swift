import Foundation
import SQLite3

private struct RowCandidate: Hashable {
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
                        return shortcut(text: text)
                default:
                        return fetch(text: text, segmentation: segmentation)
                }
        }

        private static func fetch(text: String, segmentation: Segmentation) -> [CoreCandidate] {
                guard let bestScheme: SyllableScheme = segmentation.first, !bestScheme.isEmpty else {
                        return processVerbatim(text)
                }
                switch (text.hasSeparators, text.hasTones) {
                case (true, true):
                        let syllable = text.removedSpacesTonesSeparators()
                        let candidates = match(text: syllable)
                        let filtered = candidates.filter({ text.hasPrefix($0.romanization) }).map({ Candidate(text: $0.text, romanization: $0.romanization, input: text) })
                        return filtered
                case (false, true):
                        let matches = segmentation.map({ scheme -> [Candidate] in
                                let joinedText = scheme.joined()
                                let pingText = joinedText.removedTones()
                                return match(text: pingText).map({ Candidate(text: $0.text, romanization: $0.romanization, input: joinedText) })
                        })
                        let candidates: [Candidate] = matches.flatMap({ $0 })
                        let filtered = candidates.filter({ item -> Bool in
                                let continuous = item.romanization.filter({ !$0.isSpace })
                                return continuous.hasPrefix(text) || text.hasPrefix(continuous)
                        })
                        return filtered
                case (true, false):
                        let matches = segmentation.map({ scheme -> [Candidate] in
                                let joinedText = scheme.joined()
                                return match(text: joinedText)
                        })
                        let candidates: [Candidate] = matches.flatMap({ $0 })
                        let separatedPartCount = text.split(separator: "'").count
                        let filtered = candidates.filter({ item -> Bool in
                                let syllables = item.romanization.removedTones().split(separator: " ")
                                let syllableCount = syllables.count
                                guard syllableCount <= separatedPartCount else { return false }
                                guard syllableCount < separatedPartCount else { return true }
                                let joinedSyllables = syllables.joined(separator: "'")
                                return text.hasPrefix(joinedSyllables)
                        })
                        return filtered
                case (false, false):
                        let convertedText = text.replacingOccurrences(of: "(?<!c|s|j|z)yu(?!k|m|ng)", with: "jyu", options: .regularExpression)
                        if bestScheme.length == convertedText.count {
                                return process(text: convertedText, origin: text, segmentation: segmentation)
                        } else {
                                return processPartial(text: convertedText, origin: text, segmentation: segmentation)
                        }
                }
        }
        private static func processVerbatim(_ text: String) -> [CoreCandidate] {
                let rounds = (0..<text.count).map({ number -> [CoreCandidate] in
                        let leading: String = String(text.dropLast(number))
                        return match(text: leading) + shortcut(text: leading)
                })
                return rounds.flatMap({ $0 }).uniqued()
        }
        private static func process(text: String, origin: String, segmentation: Segmentation) -> [CoreCandidate] {
                let candidates = match(segmentation: segmentation, fullTextCount: origin.count)
                let fullProcessed: [CoreCandidate] = match(text: text) + shortcut(text: text)
                let backup: [CoreCandidate] = processVerbatim(text)
                let fallback: [CoreCandidate] = (fullProcessed + candidates + backup).uniqued()
                guard let firstCandidate = candidates.first else { return fallback }
                let firstInputCount: Int = firstCandidate.input.count
                guard firstInputCount != text.count else { return fallback }
                let tailText: String = String(text.dropFirst(firstInputCount))
                let tailSegmentation: Segmentation = Segmentor.engineSegment(tailText)
                let hasSchemes: Bool = !(tailSegmentation.first?.isEmpty ?? true)
                guard hasSchemes else { return fallback }
                let tailCandidates: [CoreCandidate] = (match(text: tailText) + shortcut(text: tailText) + match(segmentation: tailSegmentation)).uniqued()
                guard !(tailCandidates.isEmpty) else { return fallback }
                let qualified = candidates.enumerated().filter({ $0.offset < 3 && $0.element.input.count == firstInputCount })
                let combines = tailCandidates.map { tail -> [CoreCandidate] in
                        return qualified.map({ $0.element + tail })
                }
                let concatenated: [CoreCandidate] = combines.flatMap({ $0 }).enumerated().filter({ $0.offset < 4 }).map(\.element)
                return fullProcessed + concatenated + candidates + backup
        }
        private static func processPartial(text: String, origin: String, segmentation: Segmentation) -> [CoreCandidate] {
                let candidates = match(segmentation: segmentation, fullTextCount: origin.count)
                let fullProcessed: [CoreCandidate] = match(text: text) + shortcut(text: text)
                let backup: [CoreCandidate] = processVerbatim(text)
                let fallback: [CoreCandidate] = (fullProcessed + candidates + backup).uniqued()
                guard let firstCandidate = candidates.first else { return fallback }
                let firstInputCount: Int = firstCandidate.input.count
                guard firstInputCount != text.count else { return fallback }
                let anchorsArray: [String] = segmentation.map({ scheme -> String in
                        let last = text.dropFirst(scheme.length).first
                        let schemeAnchors = scheme.map({ $0.first })
                        let anchors = (schemeAnchors + [last]).compactMap({ $0 })
                        return String(anchors)
                })
                let prefixes: [CoreCandidate] = anchorsArray.map({ shortcut(text: $0) }).flatMap({ $0 })
                        .filter({ $0.romanization.removedSpacesTones().hasPrefix(text) })
                        .map({ CoreCandidate(text: $0.text, romanization: $0.romanization, input: text) })
                guard prefixes.isEmpty else { return fullProcessed + prefixes + candidates + backup }
                let tailText: String = String(text.dropFirst(firstInputCount))
                let tailCandidates = processVerbatim(tailText)
                        .filter({ item -> Bool in
                                let hasText: Bool = item.romanization.removedSpacesTones().hasPrefix(tailText)
                                guard !hasText else { return true }
                                let anchors = item.romanization.split(separator: " ").map({ $0.first }).compactMap({ $0 })
                                return anchors == tailText.map({ $0 })
                        })
                        .map({ CoreCandidate(text: $0.text, romanization: $0.romanization, input: tailText) })
                guard !(tailCandidates.isEmpty) else { return fallback }
                let qualified = candidates.enumerated().filter({ $0.offset < 3 && $0.element.input.count == firstInputCount })
                let combines = tailCandidates.map { tail -> [CoreCandidate] in
                        return qualified.map({ $0.element + tail })
                }
                let concatenated: [CoreCandidate] = combines.flatMap({ $0 }).enumerated().filter({ $0.offset < 4 }).map(\.element)
                return fullProcessed + concatenated + candidates + backup
        }
        private static func match(segmentation: Segmentation, fullTextCount: Int = -1) -> [CoreCandidate] {
                let matches = segmentation.map({ scheme -> [RowCandidate] in
                        let joinedText = scheme.joined()
                        let isExactlyMatch: Bool = joinedText.count == fullTextCount
                        return matchRow(text: joinedText, isExactlyMatch: isExactlyMatch)
                })
                let candidates: [CoreCandidate] = matches.flatMap({ $0 }).sorted().map(\.candidate)
                return candidates
        }
}

private extension Engine {

        // CREATE TABLE lexicontable(word TEXT NOT NULL, romanization TEXT NOT NULL, shortcut INTEGER NOT NULL, ping INTEGER NOT NULL);

        static func shortcut(text: String) -> [CoreCandidate] {
                var candidates: [CoreCandidate] = []
                let code: Int = text.replacingOccurrences(of: "y", with: "j").hash
                let limit: Int = 100
                let query = "SELECT word, romanization FROM lexicontable WHERE shortcut = \(code) LIMIT \(limit);"
                var statement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK {
                        while sqlite3_step(statement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(statement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(statement, 1))
                                let candidate = CoreCandidate(text: word, romanization: romanization, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(statement)
                return candidates
        }
        static func match(text: String) -> [CoreCandidate] {
                var candidates: [CoreCandidate] = []
                let query = "SELECT word, romanization FROM lexicontable WHERE ping = \(text.hash);"
                var statement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK {
                        while sqlite3_step(statement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(statement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(statement, 1))
                                let candidate = CoreCandidate(text: word, romanization: romanization, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(statement)
                return candidates
        }
        static func matchRow(text: String, isExactlyMatch: Bool) -> [RowCandidate] {
                var rowCandidates: [RowCandidate] = []
                let query = "SELECT rowid, word, romanization FROM lexicontable WHERE ping = \(text.hash);"
                var statement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK {
                        while sqlite3_step(statement) == SQLITE_ROW {
                                let rowid: Int = Int(sqlite3_column_int64(statement, 0))
                                let word: String = String(cString: sqlite3_column_text(statement, 1))
                                let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                                let candidate: CoreCandidate = CoreCandidate(text: word, romanization: romanization, input: text)
                                let rowCandidate: RowCandidate = RowCandidate(candidate: candidate, row: rowid, isExactlyMatch: isExactlyMatch)
                                rowCandidates.append(rowCandidate)
                        }
                }
                sqlite3_finalize(statement)
                return rowCandidates
        }
}
