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

        /// Character components reverse lookup from complete nine-key syllable schemes.
        /// - Parameters:
        ///   - combos: Keypad input without the reverse-lookup trigger.
        ///   - segmentation: Possible component syllable schemes for the input.
        /// - Returns: Composed characters with their Jyutping and component pre-edit marks.
        public static func structureNineKeyReverseLookup<T: RandomAccessCollection<Combo>>(combos: T, segmentation: NineKeySegmentation) -> [Lexicon] {
                guard combos.isNotEmpty else { return [] }
                let command: String = "SELECT word, romanization FROM structure_table WHERE spell_9key = ? AND complexity = ? ORDER BY rowid LIMIT ?;"
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                defer { sqlite3_finalize(statement) }
                let input = combos.compactMap(\.letters.first).joined()
                return segmentation.filter({ $0.length == combos.count })
                        .flatMap({ scheme -> [Lexicon] in
                                guard Task.isCancelled.negative else { return [] }
                                if scheme.contains(where: \.isIrregular) {
                                        let serialCommand: String = "SELECT word, romanization FROM structure_table WHERE spell = ? AND complexity = ? ORDER BY rowid LIMIT ?;"
                                        var serialStatement: OpaquePointer?
                                        guard sqlite3_prepare_v2(database, serialCommand, -1, &serialStatement, nil) == SQLITE_OK else { return [] }
                                        defer { sqlite3_finalize(serialStatement) }
                                        return match(keys: scheme.serialOriginKeys, complexity: scheme.complexity, input: input, statement: serialStatement)
                                } else {
                                        return match(code: scheme.originCombos.decimalCombinedCode, complexity: scheme.complexity, input: input, statement: statement)
                                }
                        })
                        .distinct()
                        .flatMap({ Engine.reveresLookup(text: $0.text, input: input, mark: $0.romanization.strippedTones()) })
                        .distinct()
        }

        private static func search<T: RandomAccessCollection<VirtualInputKey>>(keys: T, segmentation: Segmentation) -> [Lexicon] {
                let command: String = "SELECT word, romanization FROM structure_table WHERE spell = ? AND complexity = ? ORDER BY rowid LIMIT ?;"
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                defer { sqlite3_finalize(statement) }
                let inputLength = keys.count
                let input = keys.map(\.text).joined()
                return segmentation.filter({ $0.length == inputLength })
                        .flatMap({ match(keys: $0.originKeys, complexity: $0.complexity, input: input, statement: statement) })
                        .distinct()
        }
        private static func match<T: RandomAccessCollection<VirtualInputKey>>(keys: T, complexity: Int, input: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [Lexicon] {
                let input: String = input ?? keys.map(\.text).joined()
                return match(code: keys.conjoinedCode, complexity: complexity, input: input, limit: limit, statement: statement)
        }
        private static func match(code: Int, complexity: Int, input: String, limit: Int64? = nil, statement: OpaquePointer?) -> [Lexicon] {
                sqlite3_reset(statement)
                let code: Int64 = code.toInt64()
                let complexity: Int64 = complexity.toInt64()
                let limit: Int64 = limit ?? -1
                sqlite3_bind_int64(statement, 1, code)
                sqlite3_bind_int64(statement, 2, complexity)
                sqlite3_bind_int64(statement, 3, limit)
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
