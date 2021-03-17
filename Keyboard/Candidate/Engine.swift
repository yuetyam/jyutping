import Foundation
import SQLite3
import JyutpingDataProvider

struct Engine {

        private let provider: JyutpingDataProvider = JyutpingDataProvider()
        func close() {
                provider.close()
        }

        func suggest(for text: String, schemes: [[String]]) -> [Candidate] {
                guard !text.hasPrefix("r") else {
                        let pinyin: String = String(text.dropFirst())
                        return pinyin.isEmpty ? [] : matchPinyin(for: pinyin)
                }
                guard !text.hasPrefix("v") else {
                        let cangjie: String = String(text.dropFirst())
                        return cangjie.isEmpty ? [] : matchCangjie(for: cangjie)
                }
                switch text.count {
                case 0:
                        return []
                case 1:
                        switch text {
                        case "y":
                                return shortcut(for: "j")
                        default:
                                return shortcut(for: text)
                        }
                case 2:
                        return fetchTwoChars(text)
                case 3:
                        return fetchThreeChars(text)
                default:
                        return fetch(for: text, schemes: schemes)
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

        private func fetch(for text: String, schemes: [[String]]) -> [Candidate] {
                guard let bestScheme: [String] = schemes.first, !bestScheme.isEmpty else {
                        return processUnsplittable(text)
                }
                if bestScheme.reduce(0, {$0 + $1.count}) == text.count {
                        return process(text: text, sequences: schemes)
                } else {
                        return processPartial(text: text, sequences: schemes)
                }
        }
        
        private func processUnsplittable(_ text: String) -> [Candidate] {
                var combine: [Candidate] = match(for: text) + prefix(match: text) + shortcut(for: text)
                for number in 1..<text.count {
                        combine += shortcut(for: String(text.dropLast(number)))
                }
                return combine
        }
        private func process(text: String, sequences: [[String]]) -> [Candidate] {
                let matches: [[Candidate]] = sequences.map { matchWithRanking(for: $0.joined()) }
                let candidates: [Candidate] = matches.reduce([], +).sorted { ($0.text.count == $1.text.count) && ($1.ranking - $0.ranking) > 25000 }
                guard candidates.count > 1 && candidates[0].input.count != text.count else {
                        return candidates
                }
                let tailText: String = String(text.dropFirst(candidates[0].input.count))
                let jyutpingsSequences: [[String]] = Splitter.split(tailText)
                guard let tailJyutpings: [String] = jyutpingsSequences.first, !tailJyutpings.isEmpty else {
                        return candidates
                }
                var combine: [Candidate] = []
                for (index, _) in tailJyutpings.enumerated().reversed() {
                        let tail: String = tailJyutpings[0...index].joined()
                        if let one: Candidate = matchWithLimitCount(for: tail, count: 1).first {
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
                let matches: [[Candidate]] = sequences.map { matchWithRanking(for: $0.joined()) }
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
                        let jyutpingsSequences: [[String]] = Splitter.split(tailText)
                        guard let tailJyutpings: [String] = jyutpingsSequences.first, !tailJyutpings.isEmpty else {
                                return match(for: text) + prefix(match: text, count: 5) + combine + shortcut(for: text)
                        }
                        let rawTailJyutpings: String = tailJyutpings.joined()
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
                                        let someJPs: String = tailJyutpings[0...index].joined()
                                        if let one: Candidate = matchWithLimitCount(for: someJPs, count: 1).first {
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

        // CREATE TABLE jyutpingtable(ping INTEGER NOT NULL, shortcut INTEGER NOT NULL, prefix INTEGER NOT NULL, word TEXT NOT NULL, jyutping TEXT NOT NULL, pinyin INTEGER NOT NULL, cangjie INTEGER NOT NULL);

        func shortcut(for text: String, count: Int = 100) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT word, jyutping FROM jyutpingtable WHERE shortcut = \(text.code) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(provider.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, jyutping: jyutping, input: text, lexiconText: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        func match(for text: String) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT word, jyutping FROM jyutpingtable WHERE ping = \(text.code);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(provider.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, jyutping: jyutping, input: text, lexiconText: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        func matchWithLimitCount(for text: String, count: Int) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT word, jyutping FROM jyutpingtable WHERE ping = \(text.code) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(provider.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, jyutping: jyutping, input: text, lexiconText: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        func matchWithRanking(for text: String) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT rowid, word, jyutping FROM jyutpingtable WHERE ping = \(text.code);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(provider.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let rowid: Int = Int(sqlite3_column_int64(queryStatement, 0))
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                                let candidate: Candidate = Candidate(text: word, jyutping: jyutping, input: text, lexiconText: word, ranking: rowid)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        func prefix(match text: String, count: Int = 100) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT word, jyutping FROM jyutpingtable WHERE prefix = \(text.code) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(provider.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, jyutping: jyutping, input: text, lexiconText: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }

        func matchPinyin(for text: String) -> [Candidate] {
                var candidates: [Candidate] = []
                let queryString = "SELECT word, jyutping FROM jyutpingtable WHERE pinyin = \(text.code);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(provider.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, jyutping: jyutping, input: text, lexiconText: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        func matchCangjie(for text: String) -> [Candidate] {
                var candidates: [Candidate] = []
                let queryString = "SELECT word, jyutping FROM jyutpingtable WHERE cangjie = \(text.code);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(provider.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping: String = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, jyutping: jyutping, input: text, lexiconText: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
}
