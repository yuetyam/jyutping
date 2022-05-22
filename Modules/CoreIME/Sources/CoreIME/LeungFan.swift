import Foundation
import SQLite3

extension Lychee {

        /// LeungFan Reverse Lookup
        /// - Parameter text: Input text, e.g. "mukdaan"
        /// - Returns: An Array of CoreCandidate
        public static func leungFanLookup(for text: String) -> [CoreCandidate] {
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
                let queryString = "SELECT * FROM loengfantable WHERE ping = \(code);" // FIXME: leungfantable
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Lychee.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let character: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let lexicon = CoreLexicon(input: text, text: character)
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
