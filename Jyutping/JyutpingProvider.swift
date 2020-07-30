import Foundation
import SQLite3

struct JyutpingProvider {
        
        private static let database: OpaquePointer? = {
                let path: String = Bundle.main.path(forResource: "jyut6ping3", ofType: "sqlite3")!
                var db: OpaquePointer?
                if sqlite3_open(path, &db) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()
        
        private static let specials: String = #"abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ_0123456789-:;.,?~!@#$%^&*/\<>{}[]()+='"•。，；？！、：～（）《》「」【】"#
        static func search(for text: String) -> [String] {
                let words: String = text.filter { !specials.contains($0) }
                guard !words.isEmpty else { return [] }
                
                let matches: [String] = match(for: words)
                if !matches.isEmpty {
                        return matches
                } else {
                        var suggestion: String = ""
                        _ = words.map { char in
                                let jyutpings: [String] = match(for: String(char))
                                if !jyutpings.isEmpty {
                                        suggestion += (jyutpings[0] + " ")
                                }
                        }
                        if !suggestion.isEmpty {
                                return [suggestion]
                        } else {
                                return []
                        }
                }
        }
        
        static func match(for text: String) -> [String] {
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
