import Foundation
import SQLite3

extension Engine {

        /// Compose(LoengFan) Reverse Lookup
        /// - Parameter text: Input text. Example: mukdaan.
        /// - Returns: An Array of Candidate
        public static func composeLookup(text: String) -> [Candidate] {
                let convertedText = text
                        .replacingOccurrences(of: "vv", with: "4")
                        .replacingOccurrences(of: "xx", with: "5")
                        .replacingOccurrences(of: "qq", with: "6")
                        .replacingOccurrences(of: "v", with: "1")
                        .replacingOccurrences(of: "x", with: "2")
                        .replacingOccurrences(of: "q", with: "3")
                guard !(convertedText.hasTones) else {
                        let noToneText = convertedText.removedTones()
                        let matched = match(text: noToneText).filter({ $0.romanization.hasPrefix(convertedText) || $0.romanization.removedTones() == convertedText.dropLast() })
                        let candidates = matched.map({ item -> [CoreCandidate] in
                                let romanizations: [String] = Engine.lookup(item.text)
                                return romanizations.map({ CoreCandidate(text: item.text, romanization: $0, input: text) })
                        })
                        return candidates.flatMap({ $0 })
                }
                let textCount = text.count
                let segmentation = Segmentor.segment(text: text).filter({ $0.length == textCount })
                guard segmentation.maxLength > 0 else {
                        let matched = match(text: text)
                        let candidates = matched.map({ item -> [CoreCandidate] in
                                let romanizations: [String] = Engine.lookup(item.text)
                                return romanizations.map({ CoreCandidate(text: item.text, romanization: $0, input: text) })
                        })
                        return candidates.flatMap({ $0 })
                }
                let matches = segmentation.map({ scheme -> [CoreCandidate] in
                        let pingText = scheme.map(\.origin).joined()
                        return match(text: pingText)
                })
                let candidates = matches.flatMap({ $0 }).map({ item -> [CoreCandidate] in
                        let romanizations: [String] = Engine.lookup(item.text)
                        return romanizations.map({ CoreCandidate(text: item.text, romanization: $0, input: text) })
                })
                return candidates.flatMap({ $0 })
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
