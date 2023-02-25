import Foundation
import SQLite3

private struct ShapeLexicon: Hashable {
        let text: String
        let input: String
        let code: String
}

extension Engine {

        /// Stroke Reverse Lookup
        /// - Parameter text: Input text, e.g. "wsad"
        /// - Returns: An Array of CoreCandidate
        public static func strokeLookup(for text: String) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                let words = searchStroke(with: text)
                let candidates = words.map { item -> [CoreCandidate] in
                        let romanizations: [String] = lookup(item.text)
                        let candidates: [CoreCandidate] = romanizations.map({ CoreCandidate(text: item.text, romanization: $0, input: item.input) })
                        return candidates
                }
                return candidates.flatMap({ $0 })
        }

        private static func searchStroke(with text: String) -> [CoreLexicon] {
                let likes = like(stroke: text)
                let sortedLikes = likes.sorted { $0.code.count < $1.code.count }
                let prefixes: [CoreLexicon] = sortedLikes.map({ CoreLexicon(input: $0.input, text: $0.text) })
                let matches: [CoreLexicon] = match(stroke: text)
                let combine: [CoreLexicon] = matches + prefixes
                return combine.uniqued()
        }

        /*
        private static func strokes(of character: String) -> Int {
                guard character.count == 1 else { return 0 }
                let queryString = "SELECT stroke FROM shapetable WHERE character = '\(character)';"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        if sqlite3_step(queryStatement) == SQLITE_ROW {
                                let strokes: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                return strokes.count
                        }
                }
                return 0
        }
        */

        private static func match(stroke: String) -> [CoreLexicon] {
                var candidates: [CoreLexicon] = []
                let queryString = "SELECT character FROM shapetable WHERE stroke = '\(stroke)';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let character: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let candidate = CoreLexicon(input: stroke, text: character)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        private static func like(stroke: String) -> [ShapeLexicon] {
                var candidates: [ShapeLexicon] = []
                let queryString = "SELECT character, stroke FROM shapetable WHERE stroke LIKE '\(stroke)%' LIMIT 50;"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
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


extension Engine {

        /// Cangjie Reverse Lookup
        /// - Parameter text: Input text, e.g. "dam"
        /// - Returns: An Array of CoreCandidate
        public static func cangjieLookup(for text: String) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                let words = searchCongGit(with: text)
                let candidates = words.map { item -> [CoreCandidate] in
                        let romanizations: [String] = lookup(item.text)
                        let candidates: [CoreCandidate] = romanizations.map({ CoreCandidate(text: item.text, romanization: $0, input: item.input) })
                        return candidates
                }
                return candidates.flatMap({ $0 })
        }

        private static func searchCongGit(with text: String) -> [CoreLexicon] {
                let likes = like(cangjie: text)
                let sortedLikes = likes.sorted { $0.code.count < $1.code.count }
                let prefixes: [CoreLexicon] = sortedLikes.map({ CoreLexicon(input: $0.input, text: $0.text) })
                let matches: [CoreLexicon] = match(cangjie: text)
                let combine: [CoreLexicon] = matches + prefixes
                return combine.uniqued()
        }

        private static func match(cangjie: String) -> [CoreLexicon] {
                var candidates: [CoreLexicon] = []
                let queryString = "SELECT character FROM shapetable WHERE cangjie = '\(cangjie)';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let character: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let candidate = CoreLexicon(input: cangjie, text: character)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        private static func like(cangjie: String) -> [ShapeLexicon] {
                var candidates: [ShapeLexicon] = []
                let queryString = "SELECT character, cangjie FROM shapetable WHERE cangjie LIKE '\(cangjie)%' LIMIT 50;"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
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
}

