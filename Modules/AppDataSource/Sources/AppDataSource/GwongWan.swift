import Foundation
import SQLite3
import CommonExtensions

private extension DataMaster {
        static func matchGwongWan(for character: Character) -> GwongWanLexicon? {
                guard let code: UInt32 = character.unicodeScalars.first?.value else { return nil }
                let command: String = "SELECT * FROM gwongwantable WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                var entries: [GwongWanCharacter] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        // let code: Int = Int(sqlite3_column_int64(queryStatement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let rhyme: String = String(cString: sqlite3_column_text(statement, 2))
                        let subRime: String = String(cString: sqlite3_column_text(statement, 3))
                        let subRhymeSerial: Int = Int(sqlite3_column_int64(statement, 4))
                        let subRhymeNumber: Int = Int(sqlite3_column_int64(statement, 5))
                        let upper: String = String(cString: sqlite3_column_text(statement, 6))
                        let lower: String = String(cString: sqlite3_column_text(statement, 7))
                        let initial: String = String(cString: sqlite3_column_text(statement, 8))
                        let rounding: String = String(cString: sqlite3_column_text(statement, 9))
                        let division: String = String(cString: sqlite3_column_text(statement, 10))
                        let rhymeClass: String = String(cString: sqlite3_column_text(statement, 11))
                        let repeating: String = String(cString: sqlite3_column_text(statement, 12))
                        let tone: String = String(cString: sqlite3_column_text(statement, 13))
                        let interpretation: String = String(cString: sqlite3_column_text(statement, 14))
                        let instance = GwongWanCharacter(word: word, rhyme: rhyme, subRhyme: subRime, subRhymeSerial: subRhymeSerial, subRhymeNumber: subRhymeNumber, upper: upper, lower: lower, initial: initial, rounding: rounding, division: division, rhymeClass: rhymeClass, repeating: repeating, tone: tone, interpretation: interpretation)
                        entries.append(instance)
                }
                guard let word = entries.first?.word else { return nil }
                return GwongWanLexicon(word: word, units: entries)
        }
}

public struct GwongWan {
        public static func search(_ character: Character) -> GwongWanLexicon? {
                if let matched = DataMaster.matchGwongWan(for: character) {
                        return matched
                } else {
                        guard let traditional = String(character).convertedS2T().first else { return nil }
                        guard traditional != character else { return nil }
                        return DataMaster.matchGwongWan(for: traditional)
                }
        }
}

public struct GwongWanLexicon: Hashable, Identifiable {
        public let word: String
        public let units: [GwongWanCharacter]
        public static func ==(lhs: GwongWanLexicon, rhs: GwongWanLexicon) -> Bool {
                return lhs.word == rhs.word
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(word)
        }
        public let id: UUID = UUID()
}

/// 字頭,韻目,小韻,小韻號,小韻內序,反切上字,反切下字,聲母,呼,等,韻系,重紐,聲調,釋義
public struct GwongWanCharacter: Hashable, Identifiable {

        /// 字頭
        public let word: String

        /// 韻目
        public let rhyme: String

        /// 小韻
        public let subRhyme: String

        /// 小韻號
        public let subRhymeSerial: Int

        /// 小韻內字序
        public let subRhymeNumber: Int

        /// 反切上字
        public let upper: String

        /// 反切下字
        public let lower: String

        /// 聲母
        public let initial: String

        /// 呼. 開／合／X
        public let rounding: String

        /// 等. 一二三四X
        public let division: String

        /// 韻系
        public let rhymeClass: String

        /// 重紐. A / B / X
        public let repeating: String

        /// 聲調. 平上去入
        public let tone: String

        /// 釋義. Definition. Description.
        public let interpretation: String

        public var id: String {
                return word + upper + lower + interpretation
        }
}

extension GwongWanCharacter {

        /// 反切. 例: 德紅切
        public var faancitText: String {
                return upper + lower + "切"
        }

        /// 音韻位屬. 例: 端母　東韻　平聲　一等
        public var hierarchy: String {
                let leading: String = "\(initial)母　\(rhyme)韻　\(tone)聲"
                var parts: [String] = [leading]
                if division != "X" {
                        parts.append("\(division)等")
                }
                if rounding != "X" {
                        parts.append("\(rounding)口")
                }
                return parts.joined(separator: "　")
        }
}
