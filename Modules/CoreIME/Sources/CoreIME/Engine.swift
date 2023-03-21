import Foundation
import SQLite3

public struct Engine {

        private static var storageDatabase: OpaquePointer? = nil
        private(set) static var database: OpaquePointer? = nil
        private static var isDatabaseReady: Bool = false

        public static func prepare() {
                Segmentor.prepare()
                let shouldPrepare: Bool = !isDatabaseReady || (database == nil)
                guard shouldPrepare else { return }
                sqlite3_close_v2(storageDatabase)
                sqlite3_close_v2(database)
                guard let path: String = Bundle.module.path(forResource: "imedb", ofType: "sqlite3") else { return }
                #if os(iOS)
                guard sqlite3_open_v2(path, &database, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else { return }
                #else
                guard sqlite3_open_v2(path, &storageDatabase, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else { return }
                guard sqlite3_open_v2(":memory:", &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                let backup = sqlite3_backup_init(database, "main", storageDatabase, "main")
                guard sqlite3_backup_step(backup, -1) == SQLITE_DONE else { return }
                guard sqlite3_backup_finish(backup) == SQLITE_OK else { return }
                sqlite3_close_v2(storageDatabase)
                #endif
                isDatabaseReady = true
        }


        // MARK: - Suggestion

        public static func suggest(text: String, segmentation: Segmentation) -> [Candidate] {
                switch text.count {
                case 0:
                        return []
                case 1:
                        return shortcut(text: text)
                default:
                        return dispatch(text: text, segmentation: segmentation)
                }
        }

        private static func dispatch(text: String, segmentation: Segmentation) -> [CoreCandidate] {
                switch (text.hasSeparators, text.hasTones) {
                case (true, true):
                        let syllable = text.removedSpacesTonesSeparators()
                        let candidates = match(text: syllable, input: text)
                        let filtered = candidates.filter({ text.hasPrefix($0.romanization) })
                        return filtered
                case (false, true):
                        let candidates: [Candidate] = match(segmentation: segmentation)
                        let qualified = candidates.map({ item -> Candidate? in
                                let continuous = item.romanization.filter({ !$0.isSpace })
                                if continuous.hasPrefix(text) {
                                        return Candidate(text: item.text, romanization: item.romanization, input: text)
                                } else if text.hasPrefix(continuous) {
                                        return Candidate(text: item.text, romanization: item.romanization, input: continuous)
                                } else {
                                        return nil
                                }
                        })
                        return qualified.compactMap({ $0 })
                case (true, false):
                        let candidates: [Candidate] = match(segmentation: segmentation)
                        let textParts = text.split(separator: "'")
                        let textPartCount = textParts.count
                        let qualified = candidates.map({ item -> Candidate? in
                                let syllables = item.romanization.removedTones().split(separator: " ")
                                guard syllables != textParts else { return Candidate(text: item.text, romanization: item.romanization, input: text) }
                                let syllableCount = syllables.count
                                guard syllableCount < textPartCount else { return nil }
                                let checks = (0..<syllableCount).map { index -> Bool in
                                        let syllable = syllables[index]
                                        let part = textParts[index]
                                        return syllable == part
                                }
                                let isMatched = checks.reduce(true, { $0 && $1 })
                                guard isMatched else { return nil }
                                let tail: [Character] = Array(repeating: "i", count: syllableCount - 1)
                                let input: String = item.input + tail
                                return Candidate(text: item.text, romanization: item.romanization, input: input)

                        })
                        return qualified.compactMap({ $0 })
                case (false, false):
                        return process(text: text, segmentation: segmentation)
                }
        }

        private static func processVerbatim(text: String) -> [CoreCandidate] {
                let rounds = (0..<text.count).map({ number -> [CoreCandidate] in
                        let leading: String = String(text.dropLast(number))
                        return match(text: leading, input: text) + shortcut(text: leading)
                })
                return rounds.flatMap({ $0 }).uniqued()
        }

        private static func process(text: String, segmentation: Segmentation) -> [CoreCandidate] {
                guard segmentation.maxLength > 0 else { return processVerbatim(text: text) }
                let textCount = text.count
                let fullMatch = match(text: text, input: text)
                let fullShortcut = shortcut(text: text)
                let candidates = match(segmentation: segmentation)
                let perfectCandidates = candidates.filter({ $0.input.count == textCount })
                let primary: [CoreCandidate] = (fullMatch + perfectCandidates + fullShortcut + candidates).uniqued()
                guard let firstInputCount = primary.first?.input.count else { return processVerbatim(text: text) }
                guard firstInputCount != textCount else { return primary }
                let anchorsArray: [String] = segmentation.map({ scheme -> String in
                        let last = text.dropFirst(scheme.length).first
                        let schemeAnchors = scheme.map({ $0.text.first })
                        let anchors = (schemeAnchors + [last]).compactMap({ $0 })
                        return String(anchors)
                })
                let prefixes: [CoreCandidate] = anchorsArray.map({ shortcut(text: $0) }).flatMap({ $0 })
                        .filter({ $0.romanization.removedSpacesTones().hasPrefix(text) })
                        .map({ CoreCandidate(text: $0.text, romanization: $0.romanization, input: text) })
                guard prefixes.isEmpty else { return (prefixes + candidates).uniqued() }
                let tailText: String = String(text.dropFirst(firstInputCount))
                guard canProcess(text: tailText) else { return primary }
                let tailSegmentation = Segmentor.segment(text: tailText)
                let tailCandidates: [CoreCandidate] = process(text: tailText, segmentation: tailSegmentation)
                guard !(tailCandidates.isEmpty) else { return primary }
                let qualified = candidates.enumerated().filter({ $0.offset < 3 && $0.element.input.count == firstInputCount })
                let combines = tailCandidates.map { tail -> [CoreCandidate] in
                        return qualified.map({ $0.element + tail })
                }
                let concatenated: [CoreCandidate] = combines.flatMap({ $0 }).enumerated().filter({ $0.offset < 4 }).map(\.element)
                return (concatenated + candidates).uniqued()
        }
        private static func canProcess(text: String) -> Bool {
                guard let first = text.first else { return false }
                return !(shortcut(text: String(first)).isEmpty)
        }

        private static func match(segmentation: Segmentation) -> [CoreCandidate] {
                let matches = segmentation.map({ scheme -> [CoreCandidate] in
                        let input = scheme.map(\.text).joined()
                        let ping = scheme.map(\.origin).joined()
                        return match(text: ping, input: input)
                })
                return matches.flatMap({ $0 })
        }


        // MARK: - SQLite

        // CREATE TABLE lexicontable(word TEXT NOT NULL, romanization TEXT NOT NULL, shortcut INTEGER NOT NULL, ping INTEGER NOT NULL);

        private static func shortcut(text: String) -> [CoreCandidate] {
                var candidates: [CoreCandidate] = []
                let code: Int = text.replacingOccurrences(of: "y", with: "j").hash
                let limit: Int = 100
                let query = "SELECT word, romanization FROM lexicontable WHERE shortcut = \(code) LIMIT \(limit);"
                var statement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
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
        private static func match(text: String, input: String) -> [CoreCandidate] {
                var candidates: [CoreCandidate] = []
                let query = "SELECT word, romanization FROM lexicontable WHERE ping = \(text.hash);"
                var statement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
                        while sqlite3_step(statement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(statement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(statement, 1))
                                let candidate = CoreCandidate(text: word, romanization: romanization, input: input)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(statement)
                return candidates
        }
}
