import Foundation
import SQLite3

public struct ShapeData {

        private let database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "shape", ofType: "sqlite3") else { return nil }
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

        public func match(cangjie: String) -> [Lexicon] {
                guard !cangjie.isEmpty else { return [] }
                var candidates: [Lexicon] = []
                let queryString = "SELECT character FROM shapetable WHERE cangjie = '\(cangjie)';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let character: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let candidate: Lexicon = Lexicon(text: character, input: cangjie)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }

        public func match(stroke: String) -> [Lexicon] {
                guard !stroke.isEmpty else { return [] }
                var candidates: [Lexicon] = []
                let queryString = "SELECT character FROM shapetable WHERE stroke = '\(stroke)';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let character: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let candidate: Lexicon = Lexicon(text: character, input: stroke)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }

        public func strokes(of character: String) -> Int {
                guard character.count == 1 else { return 0 }
                let queryString = "SELECT stroke FROM shapetable WHERE character = '\(character)';"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        if sqlite3_step(queryStatement) == SQLITE_ROW {
                                let strokes: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                return strokes.count
                        }
                }
                return 0
        }
}
