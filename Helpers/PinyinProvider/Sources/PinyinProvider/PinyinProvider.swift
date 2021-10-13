import Foundation
import SQLite3

public struct PinyinProvider {

        private let database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "pinyin", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()
        private let lookupProvider: LookupProvider = LookupProvider()
        public init() {}
        public func close() {
                lookupProvider.close()
                sqlite3_close_v2(database)
        }

        public func search(for text: String) -> [JyutpingCandidate] {
                let pinyinCandidates: [PinyinCandidate] = suggest(for: text)
                let candidates: [[JyutpingCandidate]] = pinyinCandidates.map { lookup(for: $0.text, input: $0.input) }
                let concatenated: [JyutpingCandidate] = Array<JyutpingCandidate>(candidates.joined())
                return concatenated
        }
        private func lookup(for text: String, input: String) -> [JyutpingCandidate] {
                let jyutpings: [String] = lookupProvider.search(for: text).filter({ !$0.contains("?") })
                let candidates: [JyutpingCandidate] = jyutpings.map { JyutpingCandidate(text: text, jyutping: $0, input: input) }
                return candidates
        }
        func suggest(for text: String) -> [PinyinCandidate] {
                let schemes: [[String]] = Splitter.split(text)
                let schemesMatches = schemes.map({ match(for: $0.joined()) })
                let schemesCandidates = schemesMatches.joined()
                let matches: [PinyinCandidate] = Array<PinyinCandidate>(schemesCandidates)
                let candidates: [PinyinCandidate] = match(for: text) + prefixMatch(text: text) + shortcut(for: text) + matches
                return candidates.deduplicated()
        }
        private func match(for text: String) -> [PinyinCandidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [PinyinCandidate] = []
                let queryString = "SELECT word FROM pinyintable WHERE pin = \(text.hash);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let candidate: PinyinCandidate = PinyinCandidate(text: word, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        private func shortcut(for text: String, count: Int = 100) -> [PinyinCandidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [PinyinCandidate] = []
                let queryString = "SELECT word FROM pinyintable WHERE shortcut = \(text.hash) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let candidate: PinyinCandidate = PinyinCandidate(text: word, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        private func prefixMatch(text: String, count: Int = 100) -> [PinyinCandidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [PinyinCandidate] = []
                let queryString = "SELECT word FROM pinyintable WHERE prefix = \(text.hash) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let candidate: PinyinCandidate = PinyinCandidate(text: word, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
}

extension PinyinProvider {
        struct PinyinCandidate: Hashable {
                let text: String
                let input: String
        }
}

extension PinyinProvider {
        public struct JyutpingCandidate: Hashable {

                public let text: String
                public let jyutping: String
                public let input: String

                public static func == (lhs: JyutpingCandidate, rhs: JyutpingCandidate) -> Bool {
                        return lhs.text == rhs.text && lhs.jyutping == rhs.jyutping
                }
                public func hash(into hasher: inout Hasher) {
                        hasher.combine(text)
                        hasher.combine(jyutping)
                }
        }
}
