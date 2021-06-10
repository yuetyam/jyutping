import Foundation
import SQLite3

struct LookupProvider {

        private let database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "lookup", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()
        func close() {
                sqlite3_close_v2(database)
        }
        init() {}

        func search(for text: String) -> [String] {
                guard !text.isEmpty else { return [] }
                let matches: [String] = match(for: text)
                if !matches.isEmpty {
                        return matches
                } else {
                        var chars: String = text
                        var jyutpings: [String] = []
                        while !chars.isEmpty {
                                let leading = fetchLeading(for: chars)
                                jyutpings.append(leading.jyutping)
                                chars = String(chars.dropFirst(leading.charCount))
                        }
                        guard !jyutpings.isEmpty else { return [] }
                        let suggestion: String = jyutpings.joined(separator: " ")
                        return [suggestion]
                }
        }
        private func fetchLeading(for word: String) -> (jyutping: String, charCount: Int) {
                var chars: String = word
                var jyutpings: [String] = []
                var matchedCount: Int = 1
                while jyutpings.isEmpty && !chars.isEmpty {
                        jyutpings = match(for: chars)
                        matchedCount = chars.count
                        chars = String(chars.dropLast())
                }
                return (jyutpings.first ?? "?", matchedCount)
        }

        private func match(for text: String) -> [String] {
                var jyutpings: [String] = []
                let queryString = "SELECT jyutping FROM jyutpingtable WHERE word = '\(text)';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                jyutpings.append(jyutping)
                        }
                }
                sqlite3_finalize(queryStatement)
                return jyutpings.deduplicated()
        }
}
