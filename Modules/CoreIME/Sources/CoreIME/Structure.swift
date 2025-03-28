import Foundation
import SQLite3

extension Engine {

        /// Character Components Reverse Lookup. 拆字反查. 例如 木 + 木 = 林
        /// - Parameters:
        ///   - text: Text to process
        ///   - input: User input for candidates
        ///   - segmentation: Segmentation
        /// - Returns: Candidates
        public static func structureReverseLookup(text: String, input: String, segmentation: Segmentation) -> [Candidate] {
                let markFreeText = text.removedSpacesTonesSeparators()
                let matched = process(text: markFreeText, segmentation: segmentation).uniqued()
                guard matched.isNotEmpty else { return [] }
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
                                guard item.romanization.removedSpaces().hasPrefix(text).negative else { return true }
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
                let matched = match(text: text)
                let textCount = text.count
                let schemes = segmentation.filter({ $0.length == textCount })
                guard schemes.maxSchemeLength > 0 else { return matched }
                let matches = schemes.map({ scheme -> [Candidate] in
                        let pingText = scheme.map(\.origin).joined()
                        return match(text: pingText)
                })
                return matched + matches.flatMap({ $0 })
        }
        private static func match(text: String) -> [Candidate] {
                var candidates: [Candidate] = []
                let command: String = "SELECT word, romanization FROM structuretable WHERE ping = \(text.hash);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 1))
                        let instance = Candidate(text: word, romanization: romanization, input: text)
                        candidates.append(instance)
                }
                return candidates
        }
}
