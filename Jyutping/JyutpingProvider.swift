import Foundation
import SQLite3

struct JyutpingProvider {
        
        private static let database: OpaquePointer? = {
                guard let path: String = Bundle.main.path(forResource: "jyut6ping3", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open(path, &db) == SQLITE_OK {
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
                                let firstMatch = fetchLeadingJyutping(for: chars)
                                suggestion += firstMatch.jyutping + " "
                                chars = String(chars.dropFirst(firstMatch.charCount))
                        }
                        suggestion = String(suggestion.dropLast())
                        return suggestion.isEmpty ? [] : [suggestion]
                }
        }
        private static func fetchLeadingJyutping(for words: String) -> (jyutping: String, charCount: Int) {
                var chars: String = words
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
                let queryString = "SELECT * FROM jyutpingtable WHERE word = '\(text)\';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                jyutpings.append(jyutping)
                        }
                }
                sqlite3_finalize(queryStatement)
                return jyutpings
        }
}
