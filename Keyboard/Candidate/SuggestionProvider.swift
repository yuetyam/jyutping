import Foundation
import SQLite3

struct Engine {
        
        private let database: OpaquePointer? = {
                let path: String = Bundle.main.path(forResource: "jyutpingdb", ofType: "sqlite3")!
                var db: OpaquePointer?
                if sqlite3_open(path, &db) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()
        
        func suggest(for text: String) -> [CandidateText] {
                switch text.count {
                case 0:
                        return []
                case 1:
                        return suggestOne(for: text)
                default:
                        return fetch(for: text)
                }
        }
        
        private func fetch(for text: String) -> [CandidateText] {
                let fullMatch: [CandidateText] = matchRaw(for: text)
                if fullMatch.count > 10 {
                        return fullMatch
                }
                /*
                guard text.count < 13 else {
                        if let firstJyutping: String = Spliter.split(String(text.dropLast(text.count - 6))).first {
                                var combine: [CandidateText] = fullMatch
                                if fullMatch.isEmpty {
                                        combine += suggestRawPrefix(for: text, count: 3)
                                }
                                combine += match(for: firstJyutping)
                                return combine.deduplicated()
                        } else {
                                var combine: [CandidateText] = fullMatch
                                if fullMatch.isEmpty {
                                        combine += suggestPrefixInitials(for: text, count: 3)
                                }
                                combine += suggestOne(for: String(text.first!))
                                return combine.deduplicated()
                        }
                }
                */
                if Spliter.canSplit(text) {
                        var combine: [CandidateText] = fullMatch
                        if fullMatch.isEmpty {
                                combine += suggestRawPrefix(for: text, count: 2)
                        }
                        let jyutpings: [String] = Spliter.split(text)
                        let rawJyutping: String = jyutpings.reduce("", +)
                        if text == rawJyutping {
                                if jyutpings.count > 1 {
                                        for (number, _) in jyutpings.enumerated().reversed() {
                                                let prefix: String = jyutpings[0..<number].reduce("", +)
                                                combine += matchRaw(for: prefix)
                                        }
                                }
                                return combine.deduplicated()
                        } else {
                                let rawJPPlusOne: String = String(text.dropLast(text.count - rawJyutping.count - 1))
                                let jyutpingPlus: [CandidateText] = matchRawPrefix(for: rawJPPlusOne, characterCount: jyutpings.count + 1)
                                combine += jyutpingPlus + matchRaw(for: rawJyutping)
                                if jyutpings.count > 1 {
                                        for (number, _) in jyutpings.enumerated().reversed() {
                                                let prefix: String = jyutpings[0..<number].reduce("", +)
                                                combine += matchRaw(for: prefix)
                                        }
                                }
                                return combine.deduplicated()
                        }
                } else {
                        var combine: [CandidateText] = fullMatch + matchInitials(for: text)
                        if combine.isEmpty {
                                combine += suggestPrefixInitials(for: text, count: 2)
                        }
                        for number in 1..<(text.count - 1) {
                                combine += matchInitials(for: String(text.dropLast(number)))
                        }
                        combine += suggestOne(for: String(text.first!))
                        return combine.deduplicated()
                }
        }
        
        // MATCH:  word.count == 1 && jyutping.first == text
        private func suggestOne(for text: String, count: Int = 100) -> [CandidateText] {
                guard !text.isEmpty else { return [] }
                var candidates: [CandidateText] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE length(word) = 1 AND substr(jyutping, 1, 1) = '\(text)\';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while candidates.count < count && sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: CandidateText = CandidateText(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        // MATCH:  word.count == text.count && text == jyutping.initials
        private func matchInitials(for text: String, count: Int = 100) -> [CandidateText] {
                guard !text.isEmpty else { return [] }
                var like: String = ""
                for letter in text {
                        like += "\(letter)% "
                }
                like = String(like.dropLast())
                var candidates: [CandidateText] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE length(word) = \(text.count) AND jyutping LIKE \'\(like)\';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while candidates.count < count && sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: CandidateText = CandidateText(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        // MATCH:  text == jyutping.initials[0..<text.count]
        private func suggestPrefixInitials(for text: String, count: Int = 100) -> [CandidateText] {
                guard !text.isEmpty else { return [] }
                var like: String = ""
                for letter in text {
                        like += "\(letter)% "
                }
                like = String(like.dropLast())
                var candidates: [CandidateText] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE jyutping LIKE \'\(like)\';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while candidates.count < count && sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: CandidateText = CandidateText(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        // MATCH:  jyutping == text
        private func match(for text: String) -> [CandidateText] {
                guard !text.isEmpty else { return [] }
                var candidates: [CandidateText] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE jyutping = '\(text)\';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: CandidateText = CandidateText(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        // MATCH:  jyutping.dropSpaces() == text
        private func matchRaw(for text: String) -> [CandidateText] {
                guard !text.isEmpty else { return [] }
                var candidates: [CandidateText] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE REPLACE(jyutping, \' \', \'\') = '\(text)\';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: CandidateText = CandidateText(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        // MATCH:  text == jyutpingWithOutSpaces[0..<text.count] && word.count = characterCount
        private func matchRawPrefix(for text: String, characterCount: Int, count: Int = 100) -> [CandidateText] {
                guard !text.isEmpty else { return [] }
                var candidates: [CandidateText] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE length(word) = \(characterCount) AND substr(REPLACE(jyutping, \' \', \'\'), 1, \(text.count)) = \'\(text)\';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while candidates.count < count && sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: CandidateText = CandidateText(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        // MATCH:  text == jyutpingWithOutSpaces[0..<text.count]
        private func suggestRawPrefix(for text: String, count: Int = 100) -> [CandidateText] {
                guard !text.isEmpty else { return [] }
                var candidates: [CandidateText] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE substr(REPLACE(jyutping, \' \', \'\'), 1, \(text.count)) = \'\(text)\';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while candidates.count < count && sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: CandidateText = CandidateText(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
}

private extension Array where Element: Hashable {
        func deduplicated() -> [Element] {
                var set: Set<Element> = Set<Element>()
                return filter { set.insert($0).inserted }
        }
}
