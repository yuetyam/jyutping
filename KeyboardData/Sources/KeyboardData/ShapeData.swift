import Foundation
import SQLite3

public struct ShapeData {

        private struct ShapeLexicon: Hashable {
                let text: String
                let input: String
                let code: String
        }

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

        public func search(cangjie text: String) -> [Lexicon] {
                guard !text.isEmpty else { return [] }
                let likes = like(cangjie: text)
                let sortedLikes = likes.sorted { $0.code.count < $1.code.count }
                let prefixes: [Lexicon] = sortedLikes.map { Lexicon(text: $0.text, input: $0.code) }
                let matches: [Lexicon] = match(stroke: text)
                let combine: [Lexicon] = matches + prefixes
                return combine.uniqued()
        }
        public func search(stroke text: String) -> [Lexicon] {
                guard !text.isEmpty else { return [] }
                let likes = like(stroke: text)
                let sortedLikes = likes.sorted { $0.code.count < $1.code.count }
                let prefixes: [Lexicon] = sortedLikes.map { Lexicon(text: $0.text, input: $0.code) }
                let matches: [Lexicon] = match(stroke: text)
                let combine: [Lexicon] = matches + prefixes
                return combine.uniqued()
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

        private func match(cangjie: String) -> [Lexicon] {
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
        private func match(stroke: String) -> [Lexicon] {
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

        private func like(cangjie: String) -> [ShapeLexicon] {
                var candidates: [ShapeLexicon] = []
                let queryString = "SELECT character, cangjie FROM shapetable WHERE cangjie LIKE '\(cangjie)%' LIMIT 50;"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let character: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let code: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let candidate = ShapeLexicon(text: character, input: cangjie, code: code)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        private func like(stroke: String) -> [ShapeLexicon] {
                var candidates: [ShapeLexicon] = []
                let queryString = "SELECT character, stroke FROM shapetable WHERE stroke LIKE '\(stroke)%' LIMIT 50;"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let character: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let code: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let candidate = ShapeLexicon(text: character, input: stroke, code: code)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
}
