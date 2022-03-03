import Foundation
import SQLite3

public struct LoengfanProvider {

        private let database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "loengfan", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()
        public func close() {
                sqlite3_close_v2(database)
        }
        public init() {}

        public func search(for text: String) -> [Lexicon] {
                guard !(text.isEmpty) else { return [] }
                return match(for: text).uniqued()
        }

        private struct ExLexicon {
                let lexicon: Lexicon
                let romanization: String
        }
        private func match(for text: String) -> [Lexicon] {
                var exLexicons: [ExLexicon] = []
                let convertedText = convertTones(for: text)
                let noTonesText = convertedText.filter({ !$0.isNumber })
                let code = noTonesText.hash
                let queryString = "SELECT * FROM loengfantable WHERE ping = \(code);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let character: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let lexicon = Lexicon(text: character, input: text)
                                let instance = ExLexicon(lexicon: lexicon, romanization: romanization)
                                exLexicons.append(instance)
                        }
                }
                sqlite3_finalize(queryStatement)
                let tones = convertedText.filter({ $0.isNumber })
                let hasTones = !tones.isEmpty
                guard hasTones else {
                        return exLexicons.map({ $0.lexicon })
                }
                let filteredExLexicons = exLexicons.filter { item -> Bool in
                        let itemTones = item.romanization.filter({ $0.isNumber })
                        return itemTones == tones
                }
                return filteredExLexicons.map({ $0.lexicon })
        }
        private func convertTones(for text: String) -> String {
                let converted: String = text.replacingOccurrences(of: "vv", with: "4")
                        .replacingOccurrences(of: "xx", with: "5")
                        .replacingOccurrences(of: "qq", with: "6")
                        .replacingOccurrences(of: "v", with: "1")
                        .replacingOccurrences(of: "x", with: "2")
                        .replacingOccurrences(of: "q", with: "3")
                return converted
        }
}
