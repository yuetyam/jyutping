import Foundation
import SQLite3

private struct PinyinLexicon: Hashable {
        /// Lexicon text for the input
        let text: String
        /// Input text for the lexicon
        let input: String
}

extension Engine {

        public static func pinyinReverseLookup(text: String, schemes: [[String]]) -> [Candidate] {
                let candidates = search(pinyin: text, schemes: schemes).map({ Engine.reveresLookup(text: $0.text, input: $0.input) })
                return candidates.flatMap({ $0 })
        }

        private static func search(pinyin text: String, schemes: [[String]]) -> [PinyinLexicon] {
                let textCount = text.count
                let fullMatch = match(text: text)
                let fullShortcut = shortcut(text: text)
                let candidates = schemes.map({ match(text: $0.joined()) }).flatMap({ $0 })
                let perfectCandidates = candidates.filter({ $0.input.count == textCount })
                let primary: [PinyinLexicon] = (fullMatch + perfectCandidates + fullShortcut + candidates).uniqued()
                guard let firstInputCount = primary.first?.input.count else { return [] }
                guard firstInputCount != textCount else { return primary }
                let headTexts = primary.map(\.input).uniqued()
                let concatenated = headTexts.map { headText -> Array<PinyinLexicon>.SubSequence in
                        let headInputCount = headText.count
                        let tailText = String(text.dropFirst(headInputCount))
                        let tailSegmentation = PinyinSegmentor.segment(text: tailText)
                        let tailCandidates = search(pinyin: tailText, schemes: tailSegmentation)
                        guard !(tailCandidates.isEmpty) else { return [] }
                        let qualified = primary.filter({ $0.input == headText }).prefix(3)
                        let combines = tailCandidates.map { tail -> [PinyinLexicon] in
                                return qualified.map({ PinyinLexicon(text: $0.text + tail.text, input: $0.input + tail.input) })
                        }
                        return combines.flatMap({ $0 }).prefix(4)
                }
                let preferredConcatenated = concatenated.flatMap({ $0 }).filter({ $0.input.count > firstInputCount }).uniqued().prefix(5)
                return preferredConcatenated + primary
        }

        private static func match(text: String) -> [PinyinLexicon] {
                var items: [PinyinLexicon] = []
                let query = "SELECT word FROM pinyintable WHERE pin = \(text.hash);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let candidate = PinyinLexicon(text: word, input: text)
                        items.append(candidate)
                }
                return items
        }
        private static func shortcut(text: String) -> [PinyinLexicon] {
                var items: [PinyinLexicon] = []
                let query = "SELECT word FROM pinyintable WHERE shortcut = \(text.hash) LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let candidate = PinyinLexicon(text: word, input: text)
                        items.append(candidate)
                }
                return items
        }
}
