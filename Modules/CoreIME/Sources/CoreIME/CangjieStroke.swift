import Foundation
import SQLite3

private struct ShapeLexicon: Hashable {
        let text: String
        let input: String
        let code: String
}

extension Engine {
        public static func cangjieReverseLookup(text: String) -> [Candidate] {
                let matched = match(cangjie: text)
                let globed = glob(cangjie: text).sorted(by: { $0.code.count < $1.code.count })
                let combined = (matched + globed).uniqued()
                let candidates = combined.map({ Engine.reveresLookup(text: $0.text, input: $0.input) })
                return candidates.flatMap({ $0 })
        }
        private static func match(cangjie: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                let query: String = "SELECT word FROM shapetable WHERE cangjie = '\(cangjie)';"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let instance = ShapeLexicon(text: word, input: cangjie, code: cangjie)
                        items.append(instance)
                }
                return items
        }
        private static func glob(cangjie: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                let query: String = "SELECT word, cangjie FROM shapetable WHERE cangjie GLOB '\(cangjie)*' LIMIT 50;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let code: String = String(cString: sqlite3_column_text(statement, 1))
                        let instance = ShapeLexicon(text: word, input: cangjie, code: code)
                        items.append(instance)
                }
                return items
        }
}

extension Engine {
        public static func strokeReverseLookup(text: String) -> [Candidate] {
                let matched = match(stroke: text)
                let globed = glob(stroke: text).sorted(by: { $0.code.count < $1.code.count })
                let combined = (matched + globed).uniqued()
                let candidates = combined.map({ Engine.reveresLookup(text: $0.text, input: $0.input) })
                return candidates.flatMap({ $0 })
        }
        private static func match(stroke: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                let query: String = "SELECT word FROM shapetable WHERE stroke = '\(stroke)';"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let instance = ShapeLexicon(text: word, input: stroke, code: stroke)
                        items.append(instance)
                }
                return items
        }
        private static func glob(stroke: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                let query: String = "SELECT word, stroke FROM shapetable WHERE stroke GLOB '\(stroke)*' LIMIT 50;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let code: String = String(cString: sqlite3_column_text(statement, 1))
                        let instance = ShapeLexicon(text: word, input: stroke, code: code)
                        items.append(instance)
                }
                return items
        }
}
