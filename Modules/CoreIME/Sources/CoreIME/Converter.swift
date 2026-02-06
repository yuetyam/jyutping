import Foundation
import SQLite3
import CommonExtensions

extension Converter {

        /// Merge and normalize multiple candidate sources into a single list.
        /// - Parameters:
        ///   - memory: Candidates from InputMemory — all Cantonese.
        ///   - defined: User-defined candidates from System Text Replacements — all plain text.
        ///   - marks: TextMark candidates suggested by the Engine — all plain text.
        ///   - symbols: Emoji / symbol candidates suggested by the Engine.
        ///   - queried: Candidates suggested by the Engine — all Cantonese.
        ///   - commentForm: Romanization Form. Full, tone-free, or none.
        ///   - charset: The Chinese character set to use (e.g., Traditional or Simplified).
        /// - Returns: A merged array of unique, converted candidates.
        public static func dispatch(memory: [Lexicon], defined: [Lexicon], marks: [Lexicon], symbols: [Lexicon], queried: [Lexicon], commentForm: RomanizationForm, charset: CharacterStandard) -> [Candidate] {
                let idealMemory = memory.filter(\.isIdealInputMemory)
                let notIdealMemory = memory.filter(\.isNotIdealInputMemory)
                var chained: [Lexicon] = idealMemory.isEmpty ? queried : queried.filter(\.isCompound.negative)
                for entry in notIdealMemory.reversed() {
                        if let index = chained.firstIndex(where: { $0.inputCount <= entry.inputCount }) {
                                chained.insert(entry, at: index)
                        } else {
                                chained.append(entry)
                        }
                }
                chained = idealMemory.prefix(3) + defined + marks + idealMemory + chained
                for symbol in symbols.reversed() {
                        if let index = chained.firstIndex(where: { $0.isCantonese && $0.text == symbol.attached && $0.romanization == symbol.romanization }) {
                                chained.insert(symbol, at: index + 1)
                        }
                }
                return chained.transformed(commentForm: commentForm, charset: charset).distinct()
        }
        public static func ambiguouslyDispatch(memory: [Lexicon], defined: [Lexicon], marks: [Lexicon], symbols: [Lexicon], queried: [Lexicon], commentForm: RomanizationForm, charset: CharacterStandard) -> [Candidate] {
                var chained = memory.prefix(2) + defined + memory + marks + queried.sorted()
                for symbol in symbols.reversed() {
                        if let index = chained.firstIndex(where: { $0.isCantonese && $0.text == symbol.attached && $0.romanization == symbol.romanization }) {
                                chained.insert(symbol, at: index + 1)
                        }
                }
                return chained.transformed(commentForm: commentForm, charset: charset).distinct()
        }
}

extension RandomAccessCollection where Element == Lexicon {
        public func transformed(commentForm: RomanizationForm, charset: CharacterStandard) -> [Candidate] {
                switch charset {
                case .preset, .custom, .etymology, .opencc:
                        return map({ Candidate(text: $0.text, lexicon: $0, commentForm: commentForm, charset: charset) })
                case .inherited, .hongkong, .taiwan, .ancientBooksPublishing:
                        let statement: OpaquePointer? = {
                                let query: String = "SELECT right FROM \(charset.variantTableName) WHERE left = ? LIMIT 1;"
                                var pointer: OpaquePointer? = nil
                                guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                                return pointer
                        }()
                        defer { sqlite3_finalize(statement) }
                        return map({ origin -> Candidate in
                                guard origin.isCantonese else {
                                        return Candidate(text: origin.text, lexicon: origin, commentForm: commentForm, charset: charset)
                                }
                                let converted = origin.text.map({ Converter.match(character: $0, statement: statement) })
                                return Candidate(text: String(converted), lexicon: origin, commentForm: commentForm, charset: charset)
                        })
                case .prcGeneral:
                        let statement: OpaquePointer? = {
                                let query: String = "SELECT right FROM \(charset.variantTableName) WHERE left = ? LIMIT 1;"
                                var pointer: OpaquePointer? = nil
                                guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                                return pointer
                        }()
                        defer { sqlite3_finalize(statement) }
                        return map({ origin -> Candidate in
                                guard origin.isCantonese else {
                                        return Candidate(text: origin.text, lexicon: origin, commentForm: commentForm, charset: charset)
                                }
                                let converted = Converter.prcGeneralConvert(origin.text, statement: statement)
                                return Candidate(text: converted, lexicon: origin, commentForm: commentForm, charset: charset)
                        })
                case .mutilated:
                        let statement: OpaquePointer? = {
                                let query: String = "SELECT right FROM \(charset.variantTableName) WHERE left = ? LIMIT 1;"
                                var pointer: OpaquePointer? = nil
                                guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                                return pointer
                        }()
                        defer { sqlite3_finalize(statement) }
                        return map({ origin -> Candidate in
                                guard origin.isCantonese else {
                                        return Candidate(text: origin.text, lexicon: origin, commentForm: commentForm, charset: charset)
                                }
                                let converted = Converter.mutilatedCovert(origin.text, statement: statement)
                                return Candidate(text: converted, lexicon: origin, commentForm: commentForm, charset: charset)
                        })
                }
        }
}

/*
extension RandomAccessCollection where Element == Candidate {

        /// Convert Cantonese Candidate text to the specific variant
        /// - Parameter variant: Character variant
        /// - Returns: Transformed Candidates
        public func transformed(to variant: CharacterStandard) -> [Candidate] {
                switch variant {
                case .preset, .custom, .etymology, .opencc:
                        return (self is Array<Candidate>) ? (self as! Array<Candidate>) : Array<Candidate>(self)
                case .inherited, .hongkong, .taiwan, .ancientBooksPublishing:
                        let statement: OpaquePointer? = {
                                let query: String = "SELECT right FROM \(variant.variantTableName) WHERE left = ? LIMIT 1;"
                                var pointer: OpaquePointer? = nil
                                guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                                return pointer
                        }()
                        defer { sqlite3_finalize(statement) }
                        return self.map { origin -> Candidate in
                                guard origin.isCantonese else { return origin }
                                let converted = origin.lexiconText.map({ Converter.match(character: $0, statement: statement) })
                                return Candidate(text: String(converted), lexiconText: origin.lexiconText, romanization: origin.romanization, input: origin.input, mark: origin.mark, order: origin.order)
                        }
                case .prcGeneral:
                        let statement: OpaquePointer? = {
                                let query: String = "SELECT right FROM \(variant.variantTableName) WHERE left = ? LIMIT 1;"
                                var pointer: OpaquePointer? = nil
                                guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                                return pointer
                        }()
                        defer { sqlite3_finalize(statement) }
                        return self.map { origin -> Candidate in
                                guard origin.isCantonese else { return origin }
                                let convertedText: String = Converter.prcGeneralConvert(origin.lexiconText, statement: statement)
                                return Candidate(text: convertedText, lexiconText: origin.lexiconText, romanization: origin.romanization, input: origin.input, mark: origin.mark, order: origin.order)
                        }
                case .mutilated:
                        let statement: OpaquePointer? = {
                                let query: String = "SELECT right FROM \(variant.variantTableName) WHERE left = ? LIMIT 1;"
                                var pointer: OpaquePointer? = nil
                                guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                                return pointer
                        }()
                        defer { sqlite3_finalize(statement) }
                        return self.map { origin -> Candidate in
                                guard origin.isCantonese else { return origin }
                                let convertedText: String = Converter.mutilatedCovert(origin.lexiconText, statement: statement)
                                return Candidate(text: convertedText, lexiconText: origin.lexiconText, romanization: origin.romanization, input: origin.input, mark: origin.mark, order: origin.order)
                        }
                }
        }
}
*/

/// Character Variant Converter
public struct Converter {

        /// Convert original (traditional) text to the specific variant
        /// - Parameters:
        ///   - text: Original (traditional) text
        ///   - variant: Character Variant
        /// - Returns: Converted text
        public static func convert(_ text: String, to variant: CharacterStandard) -> String {
                switch variant {
                case .preset, .custom, .etymology, .opencc:
                        return text
                case .inherited:
                        return variantMap(text: text, tableName: variant.variantTableName)
                case .hongkong:
                        return variantMap(text: text, tableName: variant.variantTableName)
                case .taiwan:
                        return variantMap(text: text, tableName: variant.variantTableName)
                case .prcGeneral:
                        let statement: OpaquePointer? = {
                                let query: String = "SELECT right FROM \(variant.variantTableName) WHERE left = ? LIMIT 1;"
                                var pointer: OpaquePointer? = nil
                                guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                                return pointer
                        }()
                        defer { sqlite3_finalize(statement) }
                        return Converter.prcGeneralConvert(text, statement: statement)
                case .ancientBooksPublishing:
                        return variantMap(text: text, tableName: variant.variantTableName)
                case .mutilated:
                        let statement: OpaquePointer? = {
                                let query: String = "SELECT right FROM \(variant.variantTableName) WHERE left = ? LIMIT 1;"
                                var pointer: OpaquePointer? = nil
                                guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                                return pointer
                        }()
                        defer { sqlite3_finalize(statement) }
                        return Converter.mutilatedCovert(text, statement: statement)
                }
        }
        private static func variantMap(text: String, tableName: String) -> String {
                let statement: OpaquePointer? = {
                        let query: String = "SELECT right FROM \(tableName) WHERE left = ? LIMIT 1;"
                        var pointer: OpaquePointer? = nil
                        guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                        return pointer
                }()
                defer { sqlite3_finalize(statement) }
                let converted = text.map({ Converter.match(character: $0, statement: statement) })
                return String(converted)
        }
        fileprivate static func match(character: Character, statement: OpaquePointer?) -> Character {
                guard let code = character.unicodeScalars.first?.value else { return character }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                guard sqlite3_step(statement) == SQLITE_ROW else { return character }
                let targetCode = Int(sqlite3_column_int64(statement, 0))
                guard let targetCharacter = Character(decimal: targetCode) else { return character }
                return targetCharacter
        }
}

private extension CharacterStandard {
        var variantTableName: String {
                switch self {
                case .inherited: "variant_old"
                case .hongkong: "variant_hk"
                case .taiwan: "variant_tw"
                case .prcGeneral: "variant_prc"
                case .ancientBooksPublishing: "variant_abp"
                case .mutilated: "variant_sim"
                default: "variant_hk"
                }
        }
}
