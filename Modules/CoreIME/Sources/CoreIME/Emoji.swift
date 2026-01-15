import Foundation
import SQLite3
import CommonExtensions

public struct Emoji: Hashable, Identifiable, Sendable {
        public enum Category: Int, Hashable, CaseIterable, Identifiable, Sendable {
                case frequent = 0
                case smileysAndPeople = 1
                case animalsAndNature = 2
                case foodAndDrink = 3
                case activity = 4
                case travelAndPlaces = 5
                case objects = 6
                case symbols = 7
                case flags = 8
                public var id: Int {
                        return self.rawValue
                }
        }
        public let category: Category
        public let uniqueNumber: Int
        public let unicodeVersion: Int
        public let text: String
        public let cantonese: String
        public let romanization: String
        public var id: Int {
                return uniqueNumber
        }

        public static func ==(lhs: Emoji, rhs: Emoji) -> Bool {
                return (lhs.category == rhs.category) && (lhs.text == rhs.text)
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(category)
                hasher.combine(text)
        }
}

extension Emoji {
        
        /// Convert an emoji text to an Emoji instance
        /// - Parameters:
        ///   - text: Text that is an emoji
        ///   - uniqueNumber: Identifiable
        /// - Returns: An Emoji instance with the .frequent category
        public static func generateFrequentEmoji(with text: String, uniqueNumber: Int) -> Emoji {
                return Emoji(category: .frequent, uniqueNumber: uniqueNumber, unicodeVersion: 110000, text: text, cantonese: String.empty, romanization: String.empty)
        }

        /// Convert code-point-text to symbol text
        /// - Parameter codes: Formatted Unicode code point text. Example: 2764.FE0F
        /// - Returns: Symbol text
        public static func generateSymbol(from codes: String) -> String? {
                let blocks = codes.split(separator: ".")
                switch blocks.count {
                case 0:
                        return nil
                case 1:
                        guard let character = character(from: codes) else { return nil }
                        return String(character)
                default:
                        let characters = blocks.compactMap(character(from:))
                        return String(characters)
                }
        }

        /// Create a Character from the given Unicode Code Point String, e.g. 1F600
        private static func character<T: StringProtocol>(from codePoint: T) -> Character? {
                guard let u32 = UInt32(codePoint, radix: 16) else { return nil }
                guard let scalar = Unicode.Scalar(u32) else { return nil }
                return Character(scalar)
        }
}

extension Engine {

        public static func fetchEmojiSequence(category: Emoji.Category? = nil) -> [Emoji] {
                let command: String = "SELECT rowid, category, unicode_version, code_point, cantonese, romanization FROM symbol_table WHERE category > 0 AND category < 9;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var emojis: [Emoji] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowid = sqlite3_column_int64(statement, 0)
                        let categoryCode = sqlite3_column_int64(statement, 1)
                        let unicodeVersion = sqlite3_column_int64(statement, 2)
                        guard let codePoint = sqlite3_column_text(statement, 3) else { continue }
                        guard let cantonese = sqlite3_column_text(statement, 4) else { continue }
                        guard let romanization = sqlite3_column_text(statement, 5) else { continue }
                        guard let category = Emoji.Category(rawValue: Int(categoryCode)),
                              let text = Emoji.generateSymbol(from: String(cString: codePoint)) else { continue }
                        let uniqueNumber: Int = 10000 + Int(rowid)
                        let instance = Emoji(category: category, uniqueNumber: uniqueNumber, unicodeVersion: Int(unicodeVersion), text: text, cantonese: String(cString: cantonese), romanization: String(cString: romanization))
                        emojis.append(instance)
                }
                return emojis
        }
        public static func fetchDefaultFrequentEmojis() -> [Emoji] {
                let command: String = "SELECT rowid, unicode_version, code_point, cantonese, romanization FROM symbol_table WHERE category = 0;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var emojis: [Emoji] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID = sqlite3_column_int64(statement, 0)
                        let unicodeVersion = sqlite3_column_int64(statement, 1)
                        guard let codePoint = sqlite3_column_text(statement, 2) else { continue }
                        guard let cantonese = sqlite3_column_text(statement, 3) else { continue }
                        guard let romanization = sqlite3_column_text(statement, 4) else { continue }
                        guard let text = Emoji.generateSymbol(from: String(cString: codePoint)) else { continue }
                        let uniqueNumber: Int = 5000 + Int(rowID)
                        let instance = Emoji(category: .frequent, uniqueNumber: uniqueNumber, unicodeVersion: Int(unicodeVersion), text: text, cantonese: String(cString: cantonese), romanization: String(cString: romanization))
                        emojis.append(instance)
                }
                return emojis
        }

        public static func searchSymbols<T: RandomAccessCollection<VirtualInputKey>>(for keys: T, segmentation: Segmentation) -> [Candidate] {
                let command: String = "SELECT category, unicode_version, code_point, cantonese, romanization FROM symbol_table WHERE spell = ?;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                let syllableKeys = keys.filter(\.isSyllableLetter)
                let syllableLength = syllableKeys.count
                let text: String = syllableKeys.map(\.text).joined()
                let input: String = (syllableLength == keys.count) ? text : keys.map(\.text).joined()
                let regular: [Candidate] = match(text: text, input: input, statement: statement)
                let schemes = segmentation.filter({ $0.length == syllableLength })
                guard schemes.isNotEmpty else { return regular }
                let matches = schemes.flatMap({ scheme -> [Candidate] in
                        let pingText = scheme.flatMap(\.origin).map(\.text).joined()
                        return match(text: pingText, input: input, statement: statement)
                })
                return (regular + matches).distinct()
        }
        private static func match<T: StringProtocol>(text: T, input: String, statement: OpaquePointer?) -> [Candidate] {
                sqlite3_reset(statement)
                guard sqlite3_bind_int64(statement, 1, Int64(text.hashCode())) == SQLITE_OK else { return [] }
                var emojis: [Emoji] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let categoryCode = sqlite3_column_int64(statement, 0)
                        let unicodeVersion = sqlite3_column_int64(statement, 1)
                        guard let codePoint = sqlite3_column_text(statement, 2) else { continue }
                        guard let cantonese = sqlite3_column_text(statement, 3) else { continue }
                        guard let romanization = sqlite3_column_text(statement, 4) else { continue }
                        let category = Emoji.Category(rawValue: Int(categoryCode)) ?? Emoji.Category.frequent
                        let instance = Emoji(category: category, uniqueNumber: Int(categoryCode), unicodeVersion: Int(unicodeVersion), text: String(cString: codePoint), cantonese: String(cString: cantonese), romanization: String(cString: romanization))
                        emojis.append(instance)
                }
                let skinToneStatement: OpaquePointer? = {
                        let skinToneQuery: String = "SELECT target FROM emoji_skin_map WHERE source = ?;"
                        var pointer: OpaquePointer? = nil
                        guard sqlite3_prepare_v2(Engine.database, skinToneQuery, -1, &pointer, nil) == SQLITE_OK else { return nil }
                        return pointer
                }()
                defer { sqlite3_finalize(skinToneStatement) }
                let candidates = emojis.compactMap({ emoji -> Candidate? in
                        let codePoint: String = emoji.text
                        let converted: String = (emoji.category == .smileysAndPeople || emoji.category == .activity) ? (mapSkinTone(source: codePoint, statement: skinToneStatement) ?? codePoint) : codePoint
                        guard let symbolText = Emoji.generateSymbol(from: converted) else { return nil }
                        return Candidate(symbol: symbolText, cantonese: emoji.cantonese, romanization: emoji.romanization, input: input, isEmoji: emoji.uniqueNumber < 10)
                })
                return candidates
        }
        private static func mapSkinTone(source: String, statement: OpaquePointer?) -> String? {
                sqlite3_reset(statement)
                guard sqlite3_bind_text(statement, 1, (source as NSString).utf8String, -1, transientDestructorType) == SQLITE_OK else { return nil }
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                guard let target = sqlite3_column_text(statement, 0) else { return nil }
                return String(cString: target)
        }

        public static func nineKeySearchSymbols<T: RandomAccessCollection<Combo>>(combos: T) -> [Candidate] {
                let nineKeyCode = combos.map(\.code).decimalCombined()
                guard nineKeyCode > 0 else { return [] }
                let command: String = "SELECT category, unicode_version, code_point, cantonese, romanization FROM symbol_table WHERE nine_key_code = ?;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                guard sqlite3_bind_int64(statement, 1, Int64(nineKeyCode)) == SQLITE_OK else { return [] }
                var emojis: [Emoji] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let categoryCode = sqlite3_column_int64(statement, 0)
                        let unicodeVersion = sqlite3_column_int64(statement, 1)
                        guard let codePoint = sqlite3_column_text(statement, 2) else { continue }
                        guard let cantonese = sqlite3_column_text(statement, 3) else { continue }
                        guard let romanization = sqlite3_column_text(statement, 4) else { continue }
                        let category = Emoji.Category(rawValue: Int(categoryCode)) ?? Emoji.Category.frequent
                        let instance = Emoji(category: category, uniqueNumber: Int(categoryCode), unicodeVersion: Int(unicodeVersion), text: String(cString: codePoint), cantonese: String(cString: cantonese), romanization: String(cString: romanization))
                        emojis.append(instance)
                }
                let skinToneStatement: OpaquePointer? = {
                        let skinToneQuery: String = "SELECT target FROM emoji_skin_map WHERE source = ?;"
                        var pointer: OpaquePointer? = nil
                        guard sqlite3_prepare_v2(Engine.database, skinToneQuery, -1, &pointer, nil) == SQLITE_OK else { return nil }
                        return pointer
                }()
                defer { sqlite3_finalize(skinToneStatement) }
                let input: String = combos.compactMap(\.letters.first).joined()
                let candidates = emojis.compactMap({ emoji -> Candidate? in
                        let codePoint: String = emoji.text
                        let converted: String = (emoji.category == .smileysAndPeople || emoji.category == .activity) ? (mapSkinTone(source: codePoint, statement: skinToneStatement) ?? codePoint) : codePoint
                        guard let symbolText = Emoji.generateSymbol(from: converted) else { return nil }
                        return Candidate(symbol: symbolText, cantonese: emoji.cantonese, romanization: emoji.romanization, input: input, isEmoji: emoji.uniqueNumber < 10)
                })
                return candidates.distinct()
        }
}
