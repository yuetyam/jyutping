import Foundation
import SQLite3

struct Engine {
        
        private let database: OpaquePointer? = {
                guard let path: String = Bundle.main.path(forResource: "jyutping", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()
        
        mutating func suggest(for text: String) -> [Candidate] {
                switch text.count {
                case 0:
                        return []
                case 1:
                        return matchInitial(for: text)
                case 2:
                        canSpilt = Spliter.canSplit(text)
                        return fetch(for: text)
                case 3, 4, 5, 6:
                        // FIXME: - Wrong way
                        if !canSpilt {
                                canSpilt = Spliter.canSplit(text)
                        }
                        return fetch(for: text)
                default:
                        return fetch(for: text)
                }
        }
        
        private var canSpilt: Bool = false
        
        private func fetch(for text: String) -> [Candidate] {
                let fullMatch: [Candidate] = match(for: text)
                guard fullMatch.count < 10 else { return fullMatch }
                
                guard canSpilt else {
                        var combine: [Candidate] = fullMatch + matchInitial(for: text)
                        for number in 1..<text.count {
                                combine += matchInitial(for: String(text.dropLast(number)))
                        }
                        return combine
                }
                
                let jyutpings: [String] = Spliter.split(text)
                let rawJyutping: String = jyutpings.reduce("", +)
                if text == rawJyutping {
                        var combine: [Candidate] = fullMatch
                        var firstMatchedJyutpingCount: Int = fullMatch.isEmpty ? 0 : jyutpings.count
                        if jyutpings.count > 1 {
                                for (number, _) in jyutpings.enumerated().reversed() {
                                        let prefix: String = jyutpings[0..<number].reduce("", +)
                                        let matched: [Candidate] = match(for: prefix)
                                        if combine.isEmpty && !matched.isEmpty {
                                                firstMatchedJyutpingCount = number
                                        }
                                        combine += matched
                                }
                        }
                        if fullMatch.isEmpty && combine.count > 2 {
                                let tailJyutpings: [String] = Array(jyutpings.dropFirst(firstMatchedJyutpingCount))
                                for (index, _) in tailJyutpings.enumerated().reversed() {
                                        let someJPs: String = tailJyutpings[0...index].reduce("", +)
                                        if let one: Candidate = match(for: someJPs, count: 1).first {
                                                let newCandidate: Candidate = combine.first! + one
                                                combine.insert(newCandidate, at: 0)
                                                if combine[1].count == combine[2].count {
                                                        let secondCandidate: Candidate = combine[2] + one
                                                        combine.insert(secondCandidate, at: 1)
                                                }
                                                break
                                        }
                                }
                        }
                        return combine
                } else {
                        var combine = fullMatch + matchPrefix(for: text, characterCount: jyutpings.count + 1, count: 10)
                        var matches: [Candidate] = match(for: rawJyutping)
                        var firstMatchedJyutpingCount: Int = matches.isEmpty ? 0 : jyutpings.count
                        if jyutpings.count > 1 {
                                for (number, _) in jyutpings.enumerated().reversed() {
                                        let prefix: String = jyutpings[0..<number].reduce("", +)
                                        let matched: [Candidate] = match(for: prefix)
                                        if matches.isEmpty && !matched.isEmpty {
                                                firstMatchedJyutpingCount = number
                                        }
                                        matches += matched
                                }
                        }
                        if !matches.isEmpty {
                                var hasTailCandidate: Bool = false
                                
                                let tailText: String = String(text.dropFirst(matches.first!.input.count))
                                let tailJyutpings: [String] = Array(jyutpings.dropFirst(firstMatchedJyutpingCount))
                                if let tailOne: Candidate = matchPrefix(for: tailText, characterCount: tailJyutpings.count + 1, count: 1).first {
                                        let newCandidate: Candidate = matches.first! + tailOne
                                        matches.insert(newCandidate, at: 0)
                                        hasTailCandidate = true
                                } else {
                                        let tailRawJyutping: String = tailJyutpings.reduce("", +)
                                        if tailText.count - tailRawJyutping.count > 1 {
                                                let tailRawJPPlusOne: String = String(tailText.dropLast(tailText.count - tailRawJyutping.count - 1))
                                                if let one = matchPrefix(for: tailRawJPPlusOne, characterCount: tailJyutpings.count + 1, count: 1).first {
                                                        let newCandidate: Candidate = matches.first! + one
                                                        matches.insert(newCandidate, at: 0)
                                                        hasTailCandidate = true
                                                }
                                        }
                                }
                                if !hasTailCandidate {
                                        for (index, _) in tailJyutpings.enumerated().reversed() {
                                                let someJPs: String = tailJyutpings[0...index].reduce("", +)
                                                if let one: Candidate = match(for: someJPs, count: 1).first {
                                                        let newCandidate: Candidate = matches.first! + one
                                                        matches.insert(newCandidate, at: 0)
                                                        break
                                                }
                                        }
                                }
                        }
                        combine += matches
                        return combine
                }
        }
}

private extension Engine {
        
        // MATCH:  initial = text
        func matchInitial(for text: String, count: Int = 100) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE initial = '\(text)\' LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        // MATCH:  rawjyutping == text
        func match(for text: String, count: Int = 200) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE rawjyutping = '\(text)\' LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        // MATCH:  text == rawjyutping[0..<text.count] && word.count = characterCount
        func matchPrefix(for text: String, characterCount: Int, count: Int = 100) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE length(word) = \(characterCount) AND substr(rawjyutping, 1, \(text.count)) = \'\(text)\' LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        // MATCH:  text == rawjyutping[0..<text.count]
        func suggestPrefix(for text: String, count: Int) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE substr(rawjyutping, 1, \(text.count)) = \'\(text)\' LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
}

/*
struct OldEngine {
        
        // MATCH:  word.count == text.count && text == jyutping.initials
        private func matchInitials(for text: String, count: Int = 100) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var like: String = ""
                for letter in text {
                        like += "\(letter)% "
                }
                like = String(like.dropLast())
                var candidates: [Candidate] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE length(word) = \(text.count) AND jyutping LIKE \'\(like)\';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while candidates.count < count && sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        // MATCH:  text == jyutpingWithOutSpaces[0..<text.count]
        private func suggestRawPrefix(for text: String, count: Int) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE substr(REPLACE(jyutping, \' \', \'\'), 1, \(text.count)) = \'\(text)\';"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while candidates.count < count && sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
}
*/
