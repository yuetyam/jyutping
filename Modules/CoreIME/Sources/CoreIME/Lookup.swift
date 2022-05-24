import Foundation
import SQLite3

extension Lychee {

        /// Search Romanization for word
        /// - Parameter text: word
        /// - Returns: Array of Romanization matched the input word
        static func lookup(_ text: String) -> [String] {
                guard !text.isEmpty else { return [] }
                let matched = match(for: text)
                guard matched.isEmpty else { return matched }
                guard text.count != 1 else { return [] }
                var chars: String = text
                var fetches: [String] = []
                while !chars.isEmpty {
                        let leading = leading(for: chars)
                        if let romanization: String = leading.romanization {
                                fetches.append(romanization)
                                let length: Int = max(1, leading.charCount)
                                chars = String(chars.dropFirst(length))
                        } else {
                                fetches.append("?")
                                chars = String(chars.dropFirst())
                        }
                }
                guard !fetches.isEmpty else { return [] }
                let suggestion: String = fetches.joined(separator: " ")
                return [suggestion]
        }

        private static func leading(for word: String) -> (romanization: String?, charCount: Int) {
                var chars: String = word
                var romanization: String? = nil
                var matchedCount: Int = 0
                while romanization == nil && !chars.isEmpty {
                        romanization = match(for: chars).first
                        matchedCount = chars.count
                        chars = String(chars.dropLast())
                }
                guard let matched: String = romanization else {
                        return (nil, 0)
                }
                return (matched, matchedCount)
        }

        private static func match(for text: String) -> [String] {
                var romanizations: [String] = []
                let queryString = "SELECT romanization FROM lookuptable WHERE word = '\(text)';"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(Lychee.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                romanizations.append(romanization)
                        }
                }
                return romanizations
        }
}
