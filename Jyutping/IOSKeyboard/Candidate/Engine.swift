import Foundation
import SQLite3
import InputMethodData

struct Engine {

        fileprivate typealias RowCandidate = (candidate: Candidate, row: Int)

        private let provider: InputMethodData = InputMethodData()
        func close() {
                provider.close()
        }

        func suggest(for text: String, schemes: [[String]]) -> [Candidate] {
                switch text.count {
                case 0:
                        return []
                case 1:
                        return shortcut(for: text)
                case 2 where !text.hasPrefix("y"):
                        return fetchTwoChars(text)
                case 3 where !(text.hasSuffix("um") || text.hasSuffix("om") || text.hasPrefix("y")):
                        return fetchThreeChars(text)
                default:
                        let filtered: String = text.replacingOccurrences(of: "'", with: "")
                        return fetch(for: filtered, origin: text, schemes: schemes)
                }
        }

        private func fetchTwoChars(_ text: String) -> [Candidate] {
                guard let firstChar = text.first, let lastChar = text.last else { return [] }
                guard !(firstChar.isSeparator || firstChar.isTone) else { return [] }
                guard !lastChar.isSeparator else { return match(for: String(firstChar)) }
                let matched: [Candidate] = match(for: text)
                guard !lastChar.isTone else { return matched }
                let shortcutTwo: [Candidate] = shortcut(for: text)
                let shortcutFirst: [Candidate] = shortcut(for: String(firstChar))
                return matched + shortcutTwo + shortcutFirst
        }
        private func fetchThreeChars(_ text: String) -> [Candidate] {
                guard let firstChar = text.first, let lastChar = text.last else { return [] }
                guard !(firstChar.isSeparator || firstChar.isTone) else { return [] }
                let medium = text[text.index(text.startIndex, offsetBy: 1)]
                let leadingTwo: String = String([firstChar, medium])
                let headTail: String = String([firstChar, lastChar])
                if medium.isSeparator {
                        if lastChar.isSeparator || lastChar.isTone {
                                return match(for: String(firstChar))
                        } else {
                                return prefix(match: headTail)
                        }
                } else if medium.isTone {
                        guard !(lastChar.isSeparator || lastChar.isTone) else {
                                return match(for: leadingTwo)
                        }
                        let fetches: [Candidate] = prefix(match: headTail)
                        let filtered: [Candidate] = fetches.filter {
                                guard let first: String = $0.romanization.components(separatedBy: String.space).first else { return false }
                                return first == leadingTwo
                        }
                        return filtered
                }
                if lastChar.isSeparator {
                        return match(for: leadingTwo)
                } else if lastChar.isTone {
                        return match(for: text)
                }
                let exactly: [Candidate] = match(for: text)
                let prefixes: [Candidate] = prefix(match: text)
                let shortcutThree: [Candidate] = shortcut(for: text)
                let shortcutTwo: [Candidate] = shortcut(for: leadingTwo)
                let matchTwo: [Candidate] = match(for: leadingTwo)
                let shortcutFirst: [Candidate] = shortcut(for: String(firstChar))

                var combine: [Candidate] = []
                if let shortcutLast1: Candidate = shortcut(for: String(lastChar), count: 1).first {
                        if let firstMatchTwo: Candidate = matchTwo.first {
                                let new: Candidate = firstMatchTwo + shortcutLast1
                                combine.append(new)
                        }
                        if let firstShortcutTwo: Candidate = matchTwo.first {
                                let new: Candidate = firstShortcutTwo + shortcutLast1
                                combine.append(new)
                        }
                }
                let head: [Candidate] = exactly + prefixes + shortcutThree
                let tail: [Candidate] = combine + shortcutTwo + matchTwo + shortcutFirst
                return head + tail
        }

        private func fetch(for text: String, origin: String, schemes: [[String]]) -> [Candidate] {
                guard let bestScheme: [String] = schemes.first, !bestScheme.isEmpty else {
                        return processUnsplittable(text)
                }
                if bestScheme.reduce(0, {$0 + $1.count}) == text.count {
                        return process(text: text, origin: origin, sequences: schemes)
                } else {
                        return processPartial(text: text, origin: origin, sequences: schemes)
                }
        }
        
        private func processUnsplittable(_ text: String) -> [Candidate] {
                var combine: [Candidate] = match(for: text) + prefix(match: text) + shortcut(for: text)
                for number in 1..<text.count {
                        let leading: String = String(text.dropLast(number))
                        combine += shortcut(for: leading)
                }
                return combine
        }
        private func process(text: String, origin: String, sequences: [[String]]) -> [Candidate] {
                let candidates: [Candidate] = {
                        let matches = sequences.map({ matchWithRowID(for: $0.joined()) }).joined()
                        let sorted = matches.sorted { $0.candidate.text.count == $1.candidate.text.count && ($1.row - $0.row) > 50000 }
                        let candidates: [Candidate] = sorted.map({ $0.candidate })
                        let hasSeparators: Bool = text.count != origin.count
                        guard hasSeparators else { return candidates }
                        let firstSyllable: String = sequences.first?.first ?? "X"
                        let filtered: [Candidate] = candidates.filter { candidate in
                                let firstJyutping: String = candidate.romanization.components(separatedBy: String.space).first ?? "Y"
                                return firstSyllable == firstJyutping.removedTones()
                        }
                        return filtered
                }()
                guard candidates.count > 1 else {
                        return candidates
                }
                let firstCandidate: Candidate = candidates[0]
                let secondCandidate: Candidate = candidates[1]
                guard firstCandidate.input != text else {
                        return candidates
                }
                let tailText: String = String(text.dropFirst(firstCandidate.input.count))
                let tailJyutpings: [String] = Splitter.peekSplit(tailText)
                guard !tailJyutpings.isEmpty else { return candidates }
                var combine: [Candidate] = []
                for (index, _) in tailJyutpings.enumerated().reversed() {
                        let tail: String = tailJyutpings[0...index].joined()
                        if let one: Candidate = matchWithLimitCount(for: tail, count: 1).first {
                                let newFirstCandidate: Candidate = firstCandidate + one
                                combine.append(newFirstCandidate)
                                if firstCandidate.input.count == secondCandidate.input.count && firstCandidate.text.count == secondCandidate.text.count {
                                        let newSecondCandidate: Candidate = secondCandidate + one
                                        combine.append(newSecondCandidate)
                                }
                                break
                        }
                }
                return combine + candidates
        }
        private func processPartial(text: String, origin: String, sequences: [[String]]) -> [Candidate] {
                let candidates: [Candidate] = {
                        let matches = sequences.map({ matchWithRowID(for: $0.joined()) }).joined()
                        let sorted = matches.sorted { $0.candidate.text.count == $1.candidate.text.count && ($1.row - $0.row) > 50000 }
                        let candidates: [Candidate] = sorted.map({ $0.candidate })
                        let hasSeparators: Bool = text.count != origin.count
                        guard hasSeparators else { return candidates }
                        let firstSyllable: String = sequences.first?.first ?? "X"
                        let filtered: [Candidate] = candidates.filter { candidate in
                                let firstJyutping: String = candidate.romanization.components(separatedBy: String.space).first ?? "Y"
                                return firstSyllable == firstJyutping.removedTones()
                        }
                        return filtered
                }()
                guard !candidates.isEmpty else {
                        return match(for: text) + prefix(match: text, count: 5) + shortcut(for: text)
                }
                let firstCandidate: Candidate = candidates[0]
                guard firstCandidate.input != text else {
                        return match(for: text) + prefix(match: text, count: 5) + candidates + shortcut(for: text)
                }
                let tailText: String = String(text.dropFirst(firstCandidate.input.count))
                if let tailOne: Candidate = prefix(match: tailText, count: 1).first {
                        let newFirst: Candidate = firstCandidate + tailOne
                        return match(for: text) + prefix(match: text, count: 5) + [newFirst] + candidates + shortcut(for: text)
                } else {
                        let tailJyutpings: [String] = Splitter.peekSplit(tailText)
                        guard !tailJyutpings.isEmpty else {
                                return match(for: text) + prefix(match: text, count: 5) + candidates + shortcut(for: text)
                        }
                        var concatenated: [Candidate] = []
                        var hasTailCandidate: Bool = false
                        let rawTailJyutpings: String = tailJyutpings.joined()
                        if tailText.count - rawTailJyutpings.count > 1 {
                                let tailRawJPPlusOne: String = String(tailText.dropLast(tailText.count - rawTailJyutpings.count - 1))
                                if let one: Candidate = prefix(match: tailRawJPPlusOne, count: 1).first {
                                        let newFirst: Candidate = firstCandidate + one
                                        concatenated.append(newFirst)
                                        hasTailCandidate = true
                                }
                        }
                        if !hasTailCandidate {
                                for (index, _) in tailJyutpings.enumerated().reversed() {
                                        let someJPs: String = tailJyutpings[0...index].joined()
                                        if let one: Candidate = matchWithLimitCount(for: someJPs, count: 1).first {
                                                let newFirst: Candidate = firstCandidate + one
                                                concatenated.append(newFirst)
                                                break
                                        }
                                }
                        }
                        return match(for: text) + prefix(match: text, count: 5) + concatenated + candidates + shortcut(for: text)
                }
        }
}

private extension Engine {

        // InputMethodData:
        // CREATE TABLE keyboardtable(word TEXT NOT NULL, romanization TEXT NOT NULL, ping INTEGER NOT NULL, shortcut INTEGER NOT NULL, prefix INTEGER NOT NULL);

        func shortcut(for text: String, count: Int = 100) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                let textHash: Int = text.replacingOccurrences(of: "y", with: "j").hash
                var candidates: [Candidate] = []
                let queryString = "SELECT word, romanization FROM keyboardtable WHERE shortcut = \(textHash) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(provider.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let candidate: Candidate = Candidate(text: word, romanization: romanization, input: text, lexiconText: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        func match(for text: String) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let tones: String = text.tones
                let hasTones: Bool = !tones.isEmpty
                let ping: String = hasTones ? text.removedTones() : text
                let queryString = "SELECT word, romanization FROM keyboardtable WHERE ping = \(ping.hash);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(provider.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                if !hasTones || tones == romanization.tones || (tones.count == 1 && text.last == romanization.last) {
                                        let candidate: Candidate = Candidate(text: word, romanization: romanization, input: text, lexiconText: word)
                                        candidates.append(candidate)
                                }
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        func matchWithLimitCount(for text: String, count: Int) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let tones: String = text.tones
                let hasTones: Bool = !tones.isEmpty
                let ping: String = hasTones ? text.removedTones() : text
                let queryString = "SELECT word, romanization FROM keyboardtable WHERE ping = \(ping.hash) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(provider.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                if !hasTones || tones == romanization.tones || (tones.count == 1 && text.last == romanization.last) {
                                        let candidate: Candidate = Candidate(text: word, romanization: romanization, input: text, lexiconText: word)
                                        candidates.append(candidate)
                                }
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        func matchWithRowID(for text: String) -> [RowCandidate] {
                guard !text.isEmpty else { return [] }
                var rowCandidates: [RowCandidate] = []
                let tones: String = text.tones
                let hasTones: Bool = !tones.isEmpty
                let ping: String = hasTones ? text.removedTones() : text
                let queryString = "SELECT rowid, word, romanization FROM keyboardtable WHERE ping = \(ping.hash);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(provider.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let rowid: Int = Int(sqlite3_column_int64(queryStatement, 0))
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 2))
                                if !hasTones || tones == romanization.tones || (tones.count == 1 && text.last == romanization.last) {
                                        let candidate: Candidate = Candidate(text: word, romanization: romanization, input: text, lexiconText: word)
                                        let rowCandidate: RowCandidate = (candidate: candidate, row: rowid)
                                        rowCandidates.append(rowCandidate)
                                }
                        }
                }
                sqlite3_finalize(queryStatement)
                return rowCandidates
        }
        
        func prefix(match text: String, count: Int = 100) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                var candidates: [Candidate] = []
                let queryString = "SELECT word, romanization FROM keyboardtable WHERE prefix = \(text.hash) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(provider.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let candidate: Candidate = Candidate(text: word, romanization: romanization, input: text, lexiconText: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
}
