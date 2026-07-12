import Foundation
import SQLite3
import CommonExtensions

extension Engine {

        /// Character Components Reverse Lookup. 拆字反查. 例如 木 + 木 = 林
        /// - Parameters:
        ///   - keys: VirtualInputKey Sequence
        ///   - segmentation: Segmentation
        /// - Returns: Lookup transformed Lexicons
        public static func structureReverseLookup<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T, segmentation: Segmentation) -> [Lexicon] {
                let syllableKeys = keys.filter(\.isSyllableLetter)
                let searched = search(keys: syllableKeys, segmentation: segmentation)
                guard searched.isNotEmpty else { return [] }
                let inputText = keys.map(\.text).joined()
                switch (keys.contains(where: \.isApostrophe), keys.contains(where: \.isToneLetter)) {
                case (true, true):
                        let text = inputText.toneConverted()
                        let textTones = text.filter(\.isCantoneseToneDigit)
                        guard textTones.count == 1 else { return [] }
                        let isToneInTail: Bool = text.last?.isCantoneseToneDigit ?? false
                        let filtered = searched.filter({ item -> Bool in
                                let tones = item.romanization.filter(\.isCantoneseToneDigit)
                                return isToneInTail ? tones.hasSuffix(textTones) : tones.hasPrefix(textTones)
                        })
                        return filtered.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: inputText) })
                case (false, true):
                        let text = inputText.toneConverted()
                        let textTones = text.filter(\.isCantoneseToneDigit)
                        switch textTones.count {
                        case 1:
                                let isToneInTail: Bool = text.last?.isCantoneseToneDigit ?? false
                                let filtered = searched.filter({ item -> Bool in
                                        guard item.romanization.strippedSpaces().hasPrefix(text).negative else { return true }
                                        let tones = item.romanization.filter(\.isCantoneseToneDigit)
                                        return isToneInTail ? tones.hasSuffix(textTones) : tones.hasPrefix(textTones)
                                })
                                return filtered.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: inputText) })
                        case 2:
                                let filtered = searched.filter({ item -> Bool in
                                        guard item.romanization.strippedSpaces().hasPrefix(text).negative else { return true }
                                        return textTones == item.romanization.filter(\.isCantoneseToneDigit)
                                })
                                return filtered.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: inputText) })
                        default:
                                let filtered = searched.filter({ item -> Bool in
                                        return item.romanization.strippedSpaces().hasPrefix(text)
                                })
                                return filtered.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: inputText) })
                        }
                case (true, false):
                        let textParts = inputText.split(separator: String.apostrophe)
                        let filtered = searched.filter({ item -> Bool in
                                let syllables = item.romanization.strippedTones().split(separator: String.space)
                                return syllables == textParts
                        })
                        return filtered.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: inputText) })
                case (false, false):
                        return searched.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: inputText) })
                }
        }

        private static func search<T: RandomAccessCollection<VirtualInputKey>>(keys: T, segmentation: Segmentation) -> [Lexicon] {
                let command: String = "SELECT word, romanization FROM structure_table WHERE spell = ? AND complex = ? ORDER BY rowid LIMIT ?;"
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                defer { sqlite3_finalize(statement) }
                let matched = match(keys: keys, statement: statement)
                let inputLength = keys.count
                let queried = segmentation.filter({ $0.length == inputLength }).flatMap({ match(keys: $0.flatMap(\.origin), statement: statement) })
                return matched + queried
        }
        private static func match<T: RandomAccessCollection<VirtualInputKey>>(keys: T, input: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [Lexicon] {
                sqlite3_reset(statement)
                let spell: Int64 = keys.conjoinedCode.toInt64()
                let complex: Int64 = keys.count.toInt64()
                let limit: Int64 = limit ?? -1
                sqlite3_bind_int64(statement, 1, spell)
                sqlite3_bind_int64(statement, 2, complex)
                sqlite3_bind_int64(statement, 3, limit)
                let input: String = input ?? keys.map(\.text).joined()
                var items: [Lexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 1))
                        let instance = Lexicon(text: word, romanization: romanization, input: input)
                        items.append(instance)
                }
                return items
        }
}
