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
        
        func suggest(for text: String) -> [Candidate] {
                switch text.count {
                case 0:
                        return []
                case 1:
                        return shortcut(for: text)
                case 2:
                        return fetchTwoChars(text)
                case 3:
                        return fetchThreeChars(text)
                default:
                        return fetch(for: text)
                }
        }
        
        private func fetchTwoChars(_ text: String) -> [Candidate] {
                let exactlyMatched: [Candidate] = match(for: text)
                let shortcutTwo: [Candidate] = shortcut(for: text)
                let shortcutFirst: [Candidate] = shortcut(for: String(text.first!))
                return exactlyMatched + shortcutTwo + shortcutFirst
        }
        
        private func fetchThreeChars(_ text: String) -> [Candidate] {
                let exactlyMatched: [Candidate] = match(for: text)
                let prefixMatches: [Candidate] = prefix(match: text)
                let shortcutThree: [Candidate] = shortcut(for: text)
                
                let matchTwoChars: [Candidate] = match(for: String(text.dropLast()))
                let shortcutTwo: [Candidate] = shortcut(for: String(text.dropLast()))
                
                let shortcutLast: [Candidate] = shortcut(for: String(text.last!), count: 1)
                var combine: [Candidate] = [Candidate]()
                if !matchTwoChars.isEmpty && !shortcutLast.isEmpty {
                        combine.append((matchTwoChars[0] + shortcutLast[0]))
                }
                if !shortcutTwo.isEmpty && !shortcutLast.isEmpty {
                        combine.append((shortcutTwo[0] + shortcutLast[0]))
                }
                
                let shortcutFirst: [Candidate] = shortcut(for: String(text.first!))
                
                let head: [Candidate] = exactlyMatched + prefixMatches + shortcutThree + combine
                let tail: [Candidate] = shortcutTwo + matchTwoChars + shortcutFirst
                return head + tail
        }
        
        private func fetch(for text: String) -> [Candidate] {
                guard Spliter.canSplit(text) else {
                        return processUnsplitable(text)
                }
                let jyutpings: [String] = Spliter.split(text)
                let rawJyutpings: String = jyutpings.reduce("", +)
                if text == rawJyutpings {
                        return processJyutping(text: text, jyutpings: jyutpings)
                } else {
                        return processPartialJyutping(text: text, jyutpings: jyutpings, rawJyutpings: rawJyutpings)
                }
        }
        private func processUnsplitable(_ text: String) -> [Candidate] {
                var combine: [Candidate] = match(for: text) + prefix(match: text) + shortcut(for: text)
                for number in 1..<text.count {
                        combine += shortcut(for: String(text.dropLast(number)))
                }
                return combine
        }
        private func processJyutping(text: String, jyutpings: [String]) -> [Candidate] {
                let fullMatch: [Candidate] = match(for: text)
                var combine: [Candidate] = [Candidate]()
                var firstMatchedJyutpingCount: Int = fullMatch.isEmpty ? 0 : jyutpings.count
                if jyutpings.count > 1 {
                        for (number, _) in jyutpings.enumerated().reversed() {
                                let prefix: String = jyutpings[0..<number].reduce("", +)
                                let matched: [Candidate] = match(for: prefix)
                                if firstMatchedJyutpingCount == 0 && !matched.isEmpty {
                                        firstMatchedJyutpingCount = number
                                }
                                combine += matched
                        }
                }
                if fullMatch.isEmpty && combine.count > 2 {
                        let tailJyutpings: [String] = Array(jyutpings.dropFirst(firstMatchedJyutpingCount))
                        for (index, _) in tailJyutpings.enumerated().reversed() {
                                let rawTailJyutpings: String = tailJyutpings[0...index].reduce("", +)
                                if let one: Candidate = match(for: rawTailJyutpings, count: 1).first {
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
                return fullMatch + prefix(match: text, count: 10) + combine + shortcut(for: text)
        }
        private func processPartialJyutping(text: String, jyutpings: [String], rawJyutpings: String) -> [Candidate] {
                var combine: [Candidate] = match(for: rawJyutpings)
                var firstMatchedJyutpingCount: Int = combine.isEmpty ? 0 : jyutpings.count
                if jyutpings.count > 1 {
                        for (number, _) in jyutpings.enumerated().reversed() {
                                let prefix: String = jyutpings[0..<number].reduce("", +)
                                let matched: [Candidate] = match(for: prefix)
                                if firstMatchedJyutpingCount == 0 && !matched.isEmpty {
                                        firstMatchedJyutpingCount = number
                                }
                                combine += matched
                        }
                }
                if !combine.isEmpty {
                        var hasTailCandidate: Bool = false
                        
                        let tailText: String = String(text.dropFirst(combine.first!.input.count))
                        let tailJyutpings: [String] = Array(jyutpings.dropFirst(firstMatchedJyutpingCount))
                        if let tailOne: Candidate = prefix(match: tailText, count: 1).first {
                                let newCandidate: Candidate = combine.first! + tailOne
                                combine.insert(newCandidate, at: 0)
                                hasTailCandidate = true
                        } else {
                                let rawTailJyutpings: String = tailJyutpings.reduce("", +)
                                if tailText.count - rawTailJyutpings.count > 1 {
                                        let tailRawJPPlusOne: String = String(tailText.dropLast(tailText.count - rawTailJyutpings.count - 1))
                                        if let one: Candidate = prefix(match: tailRawJPPlusOne, count: 1).first {
                                                let newCandidate: Candidate = combine.first! + one
                                                combine.insert(newCandidate, at: 0)
                                                hasTailCandidate = true
                                        }
                                }
                        }
                        if !hasTailCandidate {
                                for (index, _) in tailJyutpings.enumerated().reversed() {
                                        let someJPs: String = tailJyutpings[0...index].reduce("", +)
                                        if let one: Candidate = match(for: someJPs, count: 1).first {
                                                let newCandidate: Candidate = combine.first! + one
                                                combine.insert(newCandidate, at: 0)
                                                break
                                        }
                                }
                        }
                }
                return match(for: text) + prefix(match: text, count: 10) + combine + shortcut(for: text)
        }
}

private extension Engine {
        
        func shortcut(for text: String, count: Int = 100) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE shortcut = \(text.hash) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                // ping = sqlite3_column_int64(queryStatement, 0)
                                // shortcut = sqlite3_column_int64(queryStatement, 1)
                                // prefix = sqlite3_column_int64(queryStatement, 2)
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                                let jyut6ping3: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                                
                                let candidate: Candidate = Candidate(text: word, footnote: jyut6ping3, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        func match(for text: String, count: Int = 200) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE ping = \(text.hash) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                // ping = sqlite3_column_int64(queryStatement, 0)
                                // shortcut = sqlite3_column_int64(queryStatement, 1)
                                // prefix = sqlite3_column_int64(queryStatement, 2)
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                                let jyut6ping3: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                                
                                let candidate: Candidate = Candidate(text: word, footnote: jyut6ping3, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        func prefix(match text: String, count: Int = 100) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT * FROM jyutpingtable WHERE prefix = \(text.hash) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                // ping = sqlite3_column_int64(queryStatement, 0)
                                // shortcut = sqlite3_column_int64(queryStatement, 1)
                                // prefix = sqlite3_column_int64(queryStatement, 2)
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                                
                                let candidate: Candidate = Candidate(text: word, footnote: jyutping, input: text)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
}


/*
private func oldFetch20200905(for text: String) -> [Candidate] {
        let fullMatch: [Candidate] = match(for: text)
        
        guard Spliter.canSplit(text) else {
                var combine: [Candidate] = fullMatch + shortcut(for: text)
                for number in 1..<text.count {
                        combine += shortcut(for: String(text.dropLast(number)))
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
                var combine = fullMatch + predict(for: text, characterCount: jyutpings.count + 1, count: 10)
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
                        if let tailOne: Candidate = predict(for: tailText, characterCount: tailJyutpings.count + 1, count: 1).first {
                                let newCandidate: Candidate = matches.first! + tailOne
                                matches.insert(newCandidate, at: 0)
                                hasTailCandidate = true
                        } else {
                                let tailRawJyutping: String = tailJyutpings.reduce("", +)
                                if tailText.count - tailRawJyutping.count > 1 {
                                        let tailRawJPPlusOne: String = String(tailText.dropLast(tailText.count - tailRawJyutping.count - 1))
                                        if let one = predict(for: tailRawJPPlusOne, characterCount: tailJyutpings.count + 1, count: 1).first {
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
*/


/*
func predict(for text: String, characterCount: Int, count: Int = 100) -> [Candidate] {
        guard !text.isEmpty else { return [] }
        var candidates: [Candidate] = []
        let queryString = "SELECT * FROM jyutpingtable WHERE length(word) = \(characterCount) AND substr(rawjyutping, 1, \(text.count)) = '\(text)' LIMIT \(count);"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                        // ping = sqlite3_column_int64(queryStatement, 0)
                        // shortcut = sqlite3_column_int64(queryStatement, 1)
                        let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                        let jyut6ping3: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                        // rawjyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                        
                        let candidate: Candidate = Candidate(text: word, footnote: jyut6ping3, input: text)
                        candidates.append(candidate)
                }
        }
        sqlite3_finalize(queryStatement)
        return candidates
}
*/
