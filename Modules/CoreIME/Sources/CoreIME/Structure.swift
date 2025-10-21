import Foundation
import SQLite3
import CommonExtensions

extension Engine {

        /// Character Components Reverse Lookup. 拆字反查. 例如 木 + 木 = 林
        /// - Parameters:
        ///   - events: Input Events
        ///   - input: User input text
        ///   - segmentation: Segmentation
        /// - Returns: Candidates
        public static func structureReverseLookup(events: [InputEvent], input: String, segmentation: Segmentation) -> [Candidate] {
                let markFreeText = events.filter(\.isSyllableLetter).map(\.text).joined()
                let matched = search(text: markFreeText, segmentation: segmentation).distinct()
                guard matched.isNotEmpty else { return [] }
                let bodyEvents = events.dropFirst()
                let text = bodyEvents.map(\.text).joined()
                switch (bodyEvents.contains(where: \.isApostrophe), bodyEvents.contains(where: \.isToneLetter)) {
                case (true, true):
                        let isOneToneOnly: Bool = (text.count - markFreeText.count) == 2
                        guard isOneToneOnly else { return [] }
                        let textParts = text.removedTones().split(separator: "'")
                        let filtered = matched.filter({ item -> Bool in
                                let syllables = item.romanization.removedTones().split(separator: " ")
                                return (syllables == textParts) && (item.romanization.last == text.last)
                        })
                        return filtered.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: input) })
                case (false, true):
                        let isOneToneOnly: Bool = (text.count - markFreeText.count) == 1
                        let filtered = matched.filter({ item -> Bool in
                                guard item.romanization.removedSpaces().hasPrefix(text).negative else { return true }
                                guard isOneToneOnly else { return false }
                                return text.last == item.romanization.last
                        })
                        return filtered.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: input) })
                case (true, false):
                        let textParts = text.split(separator: "'")
                        let filtered = matched.filter({ item -> Bool in
                                let syllables = item.romanization.removedTones().split(separator: " ")
                                return syllables == textParts
                        })
                        return filtered.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: input) })
                case (false, false):
                        return matched.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: input) })
                }
        }
        private static func search(text: String, segmentation: Segmentation) -> [Candidate] {
                let matched = match(text: text)
                let textCount = text.count
                let schemes = segmentation.filter({ $0.length == textCount })
                let matches = schemes.flatMap({ match(text: $0.originText) })
                return matched + matches
        }
        private static func match(text: String) -> [Candidate] {
                var candidates: [Candidate] = []
                let command: String = "SELECT word, romanization FROM structuretable WHERE ping = \(text.hashCode());"
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
