import Foundation
import SQLite3

public struct StrokeProvider {

        private let database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "stroke", ofType: "sqlite3") else { return nil }
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

        public func matchStroke(for text: String) -> [StrokeCandidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [StrokeCandidate] = []
                let queryString = "SELECT word, jyutping FROM stroketable WHERE stroke = \(text.hash);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: StrokeCandidate = StrokeCandidate(text: word, jyutping: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        public func matchCangjie(for text: String) -> [StrokeCandidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [StrokeCandidate] = []
                let queryString = "SELECT word, jyutping FROM stroketable WHERE cangjie = \(text.hash);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: StrokeCandidate = StrokeCandidate(text: word, jyutping: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }

        // TODO: - Implement stroke count
}

extension StrokeProvider {
        public struct StrokeCandidate: Hashable {
                public let text: String
                public let jyutping: String
                public let input: String
        }
}
