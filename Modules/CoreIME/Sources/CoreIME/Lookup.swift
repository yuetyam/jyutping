import Foundation
import SQLite3
import CommonExtensions

extension Engine {

        /// Reverse Lookup.
        /// - Parameters:
        ///   - text: Cantonese word.
        ///   - input: User input for this word.
        ///   - mark: Formatted user input for pre-edit display.
        /// - Returns: Lookup transformed Lexicons.
        static func reveresLookup(text: String, input: String, mark: String? = nil) -> [Lexicon] {
                let romanizations: [String] = Engine.lookup(text)
                return romanizations.map({ Lexicon(text: text, romanization: $0, input: input, mark: mark) })
        }

        /// Search Romanization for word
        /// - Parameter text: Cantonese word
        /// - Returns: Array of Jyutping matched the input word
        static func lookup(_ text: String) -> [String] {
                guard text.isNotEmpty else { return [] }
                let matched = match(for: text)
                guard matched.isEmpty else { return matched }
                guard text.count > 1 else { return [] }
                var chars: String = text
                var fetches: [String] = []
                while chars.isNotEmpty {
                        let leading = fetchLeading(for: chars)
                        guard let romanization = leading.romanization else {
                                fetches = []
                                break
                        }
                        fetches.append(romanization)
                        let length: Int = max(1, leading.charCount)
                        chars = String(chars.dropFirst(length))
                }
                guard fetches.isNotEmpty else { return [] }
                let suggestion: String = fetches.joined(separator: String.space)
                return [suggestion]
        }
        private static func fetchLeading(for word: String) -> (romanization: String?, charCount: Int) {
                var chars: String = word
                var romanization: String? = nil
                var matchedLength: Int = 0
                while (romanization == nil) && chars.isNotEmpty {
                        romanization = match(for: chars).first
                        matchedLength = chars.count
                        chars = String(chars.dropLast())
                }
                guard let matched = romanization else { return (nil, 0) }
                return (matched, matchedLength)
        }
        private static func match(for text: String) -> [String] {
                let command: String = "SELECT romanization FROM core_lexicon WHERE word = ? ORDER BY rowid;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                guard sqlite3_bind_text(statement, 1, (text as NSString).utf8String, -1, DEFINED_SQLITE_TRANSIENT) == SQLITE_OK else { return [] }
                var romanizations: [String] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        if let queried = sqlite3_column_text(statement, 0) {
                                romanizations.append(String(cString: queried))
                        }
                }
                return romanizations
        }
}
