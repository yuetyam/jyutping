import Foundation
import SQLite3

struct Engine {
        
        private let database: OpaquePointer? = {
                guard let path: String = Bundle.main.path(forResource: "keyboard", ofType: "sqlite3") else { return nil }
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
                        switch text {
                        case "q":
                                return shortcut(for: "c")
                        case "r", "y":
                                return shortcut(for: "j")
                        case "v":
                                return shortcut(for: "w")
                        case "x":
                                return shortcut(for: "s")
                        default:
                                return shortcut(for: text)
                        }
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
                let jyutpingsSequences: [[String]] = Spliter.split(text)
                guard let firstSequence: [String] = jyutpingsSequences.first, !firstSequence.isEmpty else {
                        return processUnsplitable(text)
                }
                if firstSequence.reduce(0, { $0 + $1.count }) == text.count {
                        return process(text: text, sequences: jyutpingsSequences)
                } else {
                        return processPartial(text: text, sequences: jyutpingsSequences)
                }
        }
        
        private func processUnsplitable(_ text: String) -> [Candidate] {
                var combine: [Candidate] = match(for: text) + prefix(match: text) + shortcut(for: text)
                for number in 1..<text.count {
                        combine += shortcut(for: String(text.dropLast(number)))
                }
                return combine
        }
        private func process(text: String, sequences: [[String]]) -> [Candidate] {
                let matches: [[Candidate]] = sequences.map { match(for: $0.reduce("", +)) }
                let candidates: [Candidate] = matches.reduce([], +).sorted { ($0.text.count == $1.text.count) && ($1.ranking - $0.ranking) > 20000 }
                guard candidates.count > 1 && candidates[0].input.count != text.count else {
                        return candidates
                }
                let tailText: String = String(text.dropFirst(candidates[0].input.count))
                let jyutpingsSequences: [[String]] = Spliter.split(tailText)
                guard let tailJyutpings: [String] = jyutpingsSequences.first, !tailJyutpings.isEmpty else {
                        return candidates
                }
                var combine: [Candidate] = []
                for (index, _) in tailJyutpings.enumerated().reversed() {
                        let tail: String = tailJyutpings[0...index].reduce("", +)
                        if let one: Candidate = match(for: tail, count: 1).first {
                                let firstCandidate: Candidate = candidates[0] + one
                                combine.append(firstCandidate)
                                if candidates[0].input.count == candidates[1].input.count && candidates[0].text.count == candidates[1].text.count {
                                        let secondCandidate: Candidate = candidates[1] + one
                                        combine.append(secondCandidate)
                                }
                                break
                        }
                }
                return combine + candidates
        }
        private func processPartial(text: String, sequences: [[String]]) -> [Candidate] {
                let matches: [[Candidate]] = sequences.map { match(for: $0.reduce("", +)) }
                var combine: [Candidate] = matches.reduce([], +).sorted { ($0.text.count == $1.text.count) && ($1.ranking - $0.ranking) > 20000 }
                guard !combine.isEmpty else {
                        return match(for: text) + prefix(match: text, count: 5) + shortcut(for: text)
                }
                var hasTailCandidate: Bool = false
                let tailText: String = String(text.dropFirst(combine.first!.input.count))
                if let tailOne: Candidate = prefix(match: tailText, count: 1).first {
                        let newCandidate: Candidate = combine.first! + tailOne
                        combine.insert(newCandidate, at: 0)
                } else {
                        let jyutpingsSequences: [[String]] = Spliter.split(tailText)
                        guard let tailJyutpings: [String] = jyutpingsSequences.first, !tailJyutpings.isEmpty else {
                                return match(for: text) + prefix(match: text, count: 5) + combine + shortcut(for: text)
                        }
                        let rawTailJyutpings: String = tailJyutpings.reduce("", +)
                        if tailText.count - rawTailJyutpings.count > 1 {
                                let tailRawJPPlusOne: String = String(tailText.dropLast(tailText.count - rawTailJyutpings.count - 1))
                                if let one: Candidate = prefix(match: tailRawJPPlusOne, count: 1).first {
                                        let newCandidate: Candidate = combine.first! + one
                                        combine.insert(newCandidate, at: 0)
                                        hasTailCandidate = true
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
                return match(for: text) + prefix(match: text, count: 5) + combine + shortcut(for: text)
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
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                                
                                let candidate: Candidate = Candidate(text: word, footnote: jyutping, input: text, lexiconText: word)
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
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                                let ranking: Int = Int(sqlite3_column_int64(queryStatement, 5))
                                
                                let candidate: Candidate = Candidate(text: word, footnote: jyutping, input: text, lexiconText: word, ranking: ranking)
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
                                
                                let candidate: Candidate = Candidate(text: word, footnote: jyutping, input: text, lexiconText: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
}
