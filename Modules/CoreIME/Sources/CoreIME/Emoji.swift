import Foundation
import SQLite3

public struct Emoji: Hashable {
        public enum Category: Int, Hashable, CaseIterable {
                case smileysAndPeople = 1
                case animalsAndNature = 2
                case foodAndDrink = 3
                case activity = 4
                case travelAndPlaces = 5
                case objects = 6
                case symbols = 7
                case flags = 8
        }
        public let category: Category
        public let text: String
        public let cantonese: String
        public let romanization: String
}

extension Engine {

        public static func searchEmojiSymbols(for text: String) -> [Candidate] {
                let regular = matchSymbols(for: text)
                guard regular.isEmpty else { return regular }
                let convertedText: String = text.replacingOccurrences(of: "eo(ng|k)$", with: "oe$1", options: .regularExpression)
                        .replacingOccurrences(of: "oe(i|n|t)$", with: "eo$1", options: .regularExpression)
                        .replacingOccurrences(of: "eung$", with: "oeng", options: .regularExpression)
                        .replacingOccurrences(of: "(u|o)m$", with: "am", options: .regularExpression)
                        .replacingOccurrences(of: "^y(u|un|ut)$", with: "jy$1", options: .regularExpression)
                        .replacingOccurrences(of: "y", with: "j", options: .anchored)
                return matchSymbols(for: convertedText)
        }

        private static func matchSymbols(for text: String) -> [Candidate] {
                var candidates: [Candidate] = []
                let queryString = "SELECT category, codepoint, cantonese, romanization FROM symboltable WHERE ping = \(text.hash);"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                guard sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK else { return candidates }
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                        let categoryCode: Int = Int(sqlite3_column_int64(queryStatement, 0))
                        let codepoint: String = String(cString: sqlite3_column_text(queryStatement, 1))
                        let cantonese: String = String(cString: sqlite3_column_text(queryStatement, 2))
                        let romanization: String = String(cString: sqlite3_column_text(queryStatement, 3))
                        if let symbolText = generateSymbol(from: codepoint) {
                                let isEmoji: Bool = categoryCode != 9
                                let instance = Candidate(symbol: symbolText, cantonese: cantonese, romanization: romanization, input: text, isEmoji: isEmoji)
                                candidates.append(instance)
                        }
                }
                return candidates
        }

        /// Fetch Emoji from database
        /// - Parameter category: Fetch all Emoji if category is nil
        /// - Returns: An Array of Emoji
        public static func fetchEmoji(category: Emoji.Category? = nil) -> [Emoji] {
                var emojis: [Emoji] = []
                let tailQueryText: String = {
                        guard let categoryCode = category?.rawValue else { return "" }
                        return " WHERE category = \(categoryCode)"
                }()
                let queryString = "SELECT category, codepoint, cantonese, romanization FROM symboltable\(tailQueryText);"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let categoryCode: Int = Int(sqlite3_column_int64(queryStatement, 0))
                                let codepoint: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let cantonese: String = String(cString: sqlite3_column_text(queryStatement, 2))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 3))
                                if let category = Emoji.Category(rawValue: categoryCode), let text = generateSymbol(from: codepoint) {
                                        let emoji = Emoji(category: category, text: text, cantonese: cantonese, romanization: romanization)
                                        emojis.append(emoji)
                                }
                        }
                }
                return emojis
        }

        /// Convert code-point-text to symbol text
        /// - Parameter codes: Unicode code points.
        /// - Returns: Symbol text
        private static func generateSymbol(from codes: String) -> String? {
                let blocks = codes.split(separator: ".")
                switch blocks.count {
                case 0:
                        return nil
                case 1:
                        guard let character = character(from: codes) else { return nil }
                        return String(character)
                default:
                        let characters = blocks.map({ character(from: $0) }).compactMap({ $0 })
                        return String(characters)
                }
        }

        /// Create a Character from the given Unicode Code Point String, e.g. 1F600
        private static func character<S>(from codePoint: S) -> Character? where S: StringProtocol {
                guard let u32 = UInt32(codePoint, radix: 16) else { return nil }
                guard let scalar = Unicode.Scalar(u32) else { return nil }
                return Character(scalar)
        }
}


extension Engine {


        /// Search special mark for text
        /// - Parameter text: Input text
        /// - Returns: Candidate, type == .specialMark
        public static func searchMark(for text: String) -> Candidate? {
                let key: String = text.lowercased()
                guard let markText = specialMarks[key] else { return nil }
                return Candidate(mark: markText)
        }

        private static let specialMarks: [String: String] = {
                guard let url = Bundle.module.url(forResource: "marks", withExtension: "txt") else { return [:] }
                guard let content = try? String(contentsOf: url) else { return [:] }
                let sourceLines: [String] = content
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .trimmingCharacters(in: .controlCharacters)
                        .components(separatedBy: .newlines)
                        .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                        .filter({ !$0.isEmpty })
                let keys: [String] = sourceLines.map({ $0.lowercased() })
                let dict: [String: String] = Dictionary(uniqueKeysWithValues: zip(keys, sourceLines))
                return dict
        }()
}

