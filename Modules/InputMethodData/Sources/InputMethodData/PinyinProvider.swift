import Foundation
import SQLite3

public struct PinyinProvider {

        private let database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "pinyin", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()
        public func close() {
                sqlite3_close_v2(database)
        }
        public init() {}

        public func search(for text: String) -> [Lexicon] {
                guard !text.isEmpty else { return [] }
                let schemes: [[String]] = PinyinSplitter.split(text)
                let schemesMatches = schemes.map({ match(for: $0.joined()) })
                let schemesCandidates = schemesMatches.joined()
                let matches: [Lexicon] = Array<Lexicon>(schemesCandidates)
                let candidates: [Lexicon] = match(for: text) + prefixMatch(text: text) + shortcut(for: text) + matches
                return candidates.uniqued()
        }

        private func match(for text: String) -> [Lexicon] {
                guard !text.isEmpty else { return [] }
                var candidates: [Lexicon] = []
                let queryString = "SELECT word FROM pinyintable WHERE pin = \(text.hash);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let candidate: Lexicon = Lexicon(text: word, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        private func shortcut(for text: String, count: Int = 100) -> [Lexicon] {
                var candidates: [Lexicon] = []
                let queryString = "SELECT word FROM pinyintable WHERE shortcut = \(text.hash) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let candidate: Lexicon = Lexicon(text: word, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        private func prefixMatch(text: String, count: Int = 100) -> [Lexicon] {
                var candidates: [Lexicon] = []
                let queryString = "SELECT word FROM pinyintable WHERE prefix = \(text.hash) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let candidate: Lexicon = Lexicon(text: word, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
}
