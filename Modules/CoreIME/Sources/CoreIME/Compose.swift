import Foundation
import SQLite3

extension Engine {

        // TODO: - Handle separators

        /// Compose(LoengFan) Reverse Lookup
        /// - Parameters:
        ///   - text: Text to process
        ///   - input: User input for candidates
        ///   - segmentation: Segmentation
        /// - Returns: Candidates
        public static func composeReverseLookup(text: String, input: String, segmentation: Segmentation) -> [Candidate] {
                let toneFreeText = text.removedTones()
                let matched = process(text: toneFreeText, segmentation: segmentation).uniqued()
                guard !matched.isEmpty else { return [] }
                let toneCount: Int = text.count - toneFreeText.count
                guard toneCount != 0 else {
                        return matched.map(\.text).map({ Engine.reveresLookup(text: $0, input: input) }).flatMap({ $0 })
                }
                let filtered = matched.filter({ item -> Bool in
                        if item.romanization.removedSpaces().hasPrefix(text) {
                                return true
                        } else {
                                return (toneCount == 1) && (text.last == item.romanization.last)
                        }
                })
                return filtered.map(\.text).map({ Engine.reveresLookup(text: $0, input: input) }).flatMap({ $0 })
        }

        private static func process(text: String, segmentation: Segmentation) -> [CoreCandidate] {
                let textCount = text.count
                let segmentation = segmentation.filter({ $0.length == textCount })
                guard segmentation.maxLength > 0 else {
                        return match(text: text)
                }
                let matches = segmentation.map({ scheme -> [CoreCandidate] in
                        let pingText = scheme.map(\.origin).joined()
                        return match(text: pingText)
                })
                return match(text: text) + matches.flatMap({ $0 })
        }

        private static func match(text: String) -> [CoreCandidate] {
                var candidates: [CoreCandidate] = []
                let query: String = "SELECT word, romanization FROM composetable WHERE ping = \(text.hash);"
                var statement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK {
                        while sqlite3_step(statement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(statement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(statement, 1))
                                let instance = CoreCandidate(text: word, romanization: romanization, input: text)
                                candidates.append(instance)
                        }
                }
                sqlite3_finalize(statement)
                return candidates
        }
}
