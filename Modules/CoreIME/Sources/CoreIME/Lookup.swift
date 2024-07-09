import Foundation
import SQLite3

extension Engine {

        /// Reverse Lookup.
        /// - Parameters:
        ///   - text: Cantonese word text.
        ///   - input: User input for this word.
        ///   - mark: Formatted user input for pre-edit display.
        /// - Returns: Candidates.
        static func reveresLookup(text: String, input: String, mark: String? = nil) -> [Candidate] {
                let romanizations: [String] = Engine.lookup(text)
                return romanizations.map({ Candidate(text: text, romanization: $0, input: input, mark: mark) })
        }

        /// Search Romanization for word
        /// - Parameter text: word
        /// - Returns: Array of Romanization matched the input word
        static func lookup(_ text: String) -> [String] {
                guard text.isNotEmpty else { return [] }
                let matched = match(for: text)
                guard matched.isEmpty else { return matched }
                guard text.count != 1 else { return [] }
                var chars: String = text
                var fetches: [String] = []
                while chars.isNotEmpty {
                        let leading = fetchLeading(for: chars)
                        if let romanization: String = leading.romanization {
                                fetches.append(romanization)
                                let length: Int = max(1, leading.charCount)
                                chars = String(chars.dropFirst(length))
                        } else {
                                fetches.append("?")
                                chars = String(chars.dropFirst())
                        }
                }
                guard fetches.isNotEmpty else { return [] }
                let suggestion: String = fetches.joined(separator: " ")
                return [suggestion]
        }

        private static func fetchLeading(for word: String) -> (romanization: String?, charCount: Int) {
                var chars: String = word
                var romanization: String? = nil
                var matchedCount: Int = 0
                while romanization == nil && chars.isNotEmpty {
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
                let command: String = "SELECT romanization FROM lexicontable WHERE word = '\(text)';"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return romanizations }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let romanization: String = String(cString: sqlite3_column_text(statement, 0))
                        romanizations.append(romanization)
                }
                return romanizations
        }
}
