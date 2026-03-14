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
                let markFreeText = keys.filter(\.isSyllableLetter).map(\.text).joined()
                let searched = search(text: markFreeText, segmentation: segmentation)
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
                                        guard item.romanization.removedSpaces().hasPrefix(text).negative else { return true }
                                        let tones = item.romanization.filter(\.isCantoneseToneDigit)
                                        return isToneInTail ? tones.hasSuffix(textTones) : tones.hasPrefix(textTones)
                                })
                                return filtered.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: inputText) })
                        case 2:
                                let filtered = searched.filter({ item -> Bool in
                                        guard item.romanization.removedSpaces().hasPrefix(text).negative else { return true }
                                        return textTones == item.romanization.filter(\.isCantoneseToneDigit)
                                })
                                return filtered.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: inputText) })
                        default:
                                let filtered = searched.filter({ item -> Bool in
                                        return item.romanization.removedSpaces().hasPrefix(text)
                                })
                                return filtered.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: inputText) })
                        }
                case (true, false):
                        let textParts = inputText.split(separator: String.apostrophe)
                        let filtered = searched.filter({ item -> Bool in
                                let syllables = item.romanization.removedTones().split(separator: String.space)
                                return syllables == textParts
                        })
                        return filtered.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: inputText) })
                case (false, false):
                        return searched.map(\.text).flatMap({ Engine.reveresLookup(text: $0, input: inputText) })
                }
        }
        private static func search(text: String, segmentation: Segmentation) -> [Lexicon] {
                let matched = match(text: text)
                let textCount = text.count
                let queried = segmentation.filter({ $0.length == textCount }).flatMap({ match(text: $0.originText) })
                return matched + queried
        }
        private static func match(text: String) -> [Lexicon] {
                let command: String = "SELECT word, romanization FROM structure_table WHERE spell = \(text.hashCode());"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [Lexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 1))
                        let instance = Lexicon(text: word, romanization: romanization, input: text)
                        items.append(instance)
                }
                return items
        }
}
