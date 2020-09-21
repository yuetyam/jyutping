import Foundation
import SQLite3

struct JyutpingProvider {
        
        private static let database: OpaquePointer? = {
                guard let path: String = Bundle.main.path(forResource: "jyutping", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()
        
        static func search(for text: String) -> [String] {
                guard !text.isEmpty else { return [] }
                let matches: [String] = match(for: text)
                if !matches.isEmpty {
                        return matches
                } else {
                        var chars: String = text
                        var suggestion: String = ""
                        while !chars.isEmpty {
                                let leadingMatch = fetchLeadingJyutping(for: chars)
                                suggestion += leadingMatch.jyutping + " "
                                chars = String(chars.dropFirst(leadingMatch.charCount))
                        }
                        suggestion = String(suggestion.dropLast())
                        return suggestion.isEmpty ? [] : [suggestion]
                }
        }
        private static func fetchLeadingJyutping(for word: String) -> (jyutping: String, charCount: Int) {
                var chars: String = word
                var jyutpings: [String] = []
                var matchedCount: Int = 0
                while !chars.isEmpty && jyutpings.isEmpty {
                        jyutpings = match(for: chars)
                        matchedCount = chars.count
                        chars = String(chars.dropLast())
                }
                return (jyutpings.first ?? "?", matchedCount)
        }
        
        private static func match(for text: String) -> [String] {
                var jyutpings: [String] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE word = '\(text)';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                // let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                jyutpings.append(jyutping)
                        }
                }
                sqlite3_finalize(queryStatement)
                return jyutpings.deduplicated()
        }
}

private extension Array where Element: Hashable {
        func deduplicated() -> [Element] {
                var set: Set<Element> = Set<Element>()
                return filter { set.insert($0).inserted }
        }
}
