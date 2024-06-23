import Foundation
import SQLite3

extension Engine {

        /// LoengFan Reverse Lookup. 拆字、兩分反查. 例如 木 + 旦 = 查: mukdaan
        /// - Parameters:
        ///   - text: Text to process
        ///   - input: User input for candidates
        ///   - segmentation: Segmentation
        /// - Returns: Candidates
        public static func structureReverseLookup(text: String, input: String, segmentation: Segmentation) -> [Candidate] {
                let markFreeText = text.removedSpacesTonesSeparators()
                let matched = process(text: markFreeText, segmentation: segmentation).uniqued()
                guard !matched.isEmpty else { return [] }
                switch (text.hasSeparators, text.hasTones) {
                case (true, true):
                        let isOneToneOnly: Bool = (text.count - markFreeText.count) == 2
                        guard isOneToneOnly else { return [] }
                        let textParts = text.removedTones().split(separator: "'")
                        let filtered = matched.filter({ item -> Bool in
                                let syllables = item.romanization.removedTones().split(separator: " ")
                                return (syllables == textParts) && (item.romanization.last == text.last)
                        })
                        return filtered.map(\.text).map({ Engine.reveresLookup(text: $0, input: input) }).flatMap({ $0 })
                case (false, true):
                        let isOneToneOnly: Bool = (text.count - markFreeText.count) == 1
                        let filtered = matched.filter({ item -> Bool in
                                guard !(item.romanization.removedSpaces().hasPrefix(text)) else { return true }
                                guard isOneToneOnly else { return false }
                                return text.last == item.romanization.last
                        })
                        return filtered.map(\.text).map({ Engine.reveresLookup(text: $0, input: input) }).flatMap({ $0 })
                case (true, false):
                        let textParts = text.split(separator: "'")
                        let filtered = matched.filter({ item -> Bool in
                                let syllables = item.romanization.removedTones().split(separator: " ")
                                return syllables == textParts
                        })
                        return filtered.map(\.text).map({ Engine.reveresLookup(text: $0, input: input) }).flatMap({ $0 })
                case (false, false):
                        return matched.map(\.text).map({ Engine.reveresLookup(text: $0, input: input) }).flatMap({ $0 })
                }
        }

        private static func process(text: String, segmentation: Segmentation) -> [Candidate] {
                let textCount = text.count
                let segmentation = segmentation.filter({ $0.length == textCount })
                guard segmentation.maxLength > 0 else {
                        return match(text: text)
                }
                let matches = segmentation.map({ scheme -> [Candidate] in
                        let pingText = scheme.map(\.origin).joined()
                        return match(text: pingText)
                })
                return match(text: text) + matches.flatMap({ $0 })
        }

        private static func match(text: String) -> [Candidate] {
                var candidates: [Candidate] = []
                let query: String = "SELECT word, romanization FROM composetable WHERE ping = \(text.hash);"
                var statement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK {
                        while sqlite3_step(statement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(statement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(statement, 1))
                                let instance = Candidate(text: word, romanization: romanization, input: text)
                                candidates.append(instance)
                        }
                }
                sqlite3_finalize(statement)
                return candidates
        }
}
