import Foundation
import SQLite3

extension Engine {

        /// LeungFan Reverse Lookup
        /// - Parameter text: Input text, e.g. "mukdaan"
        /// - Returns: An Array of CoreCandidate
        public static func leungFanLookup(for text: String) -> [Candidate] {
                guard Engine.isDatabaseReady else { return [] }
                guard !text.isEmpty else { return [] }
                let words = match(for: text).uniqued()
                let candidates = words.map { item -> [CoreCandidate] in
                        let romanizations: [String] = lookup(item.text)
                        let candidates: [CoreCandidate] = romanizations.map({ CoreCandidate(text: item.text, romanization: $0, input: item.input) })
                        return candidates
                }
                return candidates.flatMap({ $0 })
        }

        private struct ExtendedLexicon {
                let lexicon: CoreLexicon
                let romanization: String
        }
        private static func match(for text: String) -> [CoreLexicon] {
                var exLexicons: [ExtendedLexicon] = []
                let convertedText = convertTones(for: text)
                let noTonesText = convertedText.filter({ !$0.isNumber })
                let code = noTonesText.hash
                let queryString = "SELECT word, romanization FROM composetable WHERE ping = \(code);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let lexicon = CoreLexicon(input: text, text: word)
                                let instance = ExtendedLexicon(lexicon: lexicon, romanization: romanization)
                                exLexicons.append(instance)
                        }
                }
                sqlite3_finalize(queryStatement)
                let tones = convertedText.filter(\.isNumber)
                let hasTones = !tones.isEmpty
                guard hasTones else {
                        return exLexicons.map({ $0.lexicon })
                }
                let filteredExLexicons = exLexicons.filter { item -> Bool in
                        let itemTones = item.romanization.filter(\.isNumber)
                        return itemTones == tones
                }
                return filteredExLexicons.map({ $0.lexicon })
        }
        private static func convertTones(for text: String) -> String {
                let converted: String = text.replacingOccurrences(of: "vv", with: "4")
                        .replacingOccurrences(of: "xx", with: "5")
                        .replacingOccurrences(of: "qq", with: "6")
                        .replacingOccurrences(of: "v", with: "1")
                        .replacingOccurrences(of: "x", with: "2")
                        .replacingOccurrences(of: "q", with: "3")
                return converted
        }
}

/*
extension Engine {
        /// LeungFan Reverse Lookup
        /// - Parameter text: Input text, e.g. "mukdaan"
        /// - Returns: An Array of Candidate
        public static func composeLookup(text: String) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [CoreCandidate] = []
                let code: Int = code(of: text)
                let queryString: String = "SELECT word, romanization FROM composetable WHERE ping = \(code);"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let character: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let instance = CoreCandidate(text: character, romanization: romanization, input: text, lexiconText: character)
                                candidates.append(instance)
                        }
                }
                return candidates
        }

        // TODO: Improve this with Segmentor
        private static func code(of text: String) -> Int {
                let noTones = text.filter({ !toneSet.contains($0) })
                let converted = noTones
                        .replacingOccurrences(of: "eo(ng|k)$", with: "oe$1", options: .regularExpression)
                        .replacingOccurrences(of: "oe(i|n|t)$", with: "eo$1", options: .regularExpression)
                        .replacingOccurrences(of: "eung", with: "oeng", options: [.backwards, .anchored])
                        .replacingOccurrences(of: "(u|o)m$", with: "am", options: .regularExpression)
                        .replacingOccurrences(of: "yu", with: "jyu", options: .anchored)
                        .replacingOccurrences(of: "y", with: "j", options: .anchored)
                return converted.hash
        }
        private static let toneSet: Set<Character> = Set("123456vxq")
}
*/
