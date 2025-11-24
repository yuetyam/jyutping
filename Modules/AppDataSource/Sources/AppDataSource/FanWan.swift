import Foundation
import SQLite3
import CommonExtensions

public struct FanWanUnit: Hashable, Identifiable {
        public let word: String
        public let romanization: String
        public let initial: String
        public let final: String
        public let yamyeung: String
        public let tone: String
        public let rhyme: String
        public let interpretation: String
        public let homophones: [String]
        public var id: String {
                return word + romanization
        }
        public static func ==(lhs: FanWanUnit, rhs: FanWanUnit) -> Bool {
                return (lhs.word == rhs.word) && (lhs.romanization == rhs.romanization)
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(romanization)
        }
}

public struct FanWanLexicon: Hashable, Identifiable {
        public let word: String
        public let units: [FanWanUnit]
        public static func ==(lhs: FanWanLexicon, rhs: FanWanLexicon) -> Bool {
                return lhs.word == rhs.word
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(word)
        }
        public let id: UUID = UUID()
}

// fanwan_table(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, yamyeung TEXT NOT NULL, tone TEXT NOT NULL, rhyme TEXT NOT NULL, interpretation TEXT NOT NULL);

private extension DataMaster {
        static func matchFanWan(for character: Character) -> FanWanLexicon? {
                guard let code: UInt32 = character.unicodeScalars.first?.value else { return nil }
                let command: String = "SELECT * FROM fanwan_table WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                var entries: [FanWanUnit] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        // let code: Int = Int(sqlite3_column_int64(queryStatement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let initial: String = String(cString: sqlite3_column_text(statement, 3))
                        let final: String = String(cString: sqlite3_column_text(statement, 4))
                        let yamyeung: String = String(cString: sqlite3_column_text(statement, 5))
                        let tone: String = String(cString: sqlite3_column_text(statement, 6))
                        let rhyme: String = String(cString: sqlite3_column_text(statement, 7))
                        let interpretation: String = String(cString: sqlite3_column_text(statement, 8))
                        let instance = FanWanUnit(word: word, romanization: romanization, initial: initial, final: final, yamyeung: yamyeung, tone: tone, rhyme: rhyme, interpretation: interpretation, homophones: [])
                        entries.append(instance)
                }
                guard let word = entries.first?.word else { return nil }
                return FanWanLexicon(word: word, units: entries)
        }
        static func fetchFanWanHomophones(for romanization: String) -> [String] {
                var homophones: [String] = []
                let command: String = "SELECT word FROM fanwan_table WHERE romanization = '\(romanization)' LIMIT 11;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return homophones }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let homophone: String = String(cString: sqlite3_column_text(statement, 0))
                        homophones.append(homophone)
                }
                return homophones
        }
}

public struct FanWan {
        public static func search(_ character: Character) -> FanWanLexicon? {
                if let fetched = DataMaster.matchFanWan(for: character) {
                        return process(lexicon: fetched)
                } else {
                        guard let traditional = String(character).convertedS2T().first else { return nil }
                        guard traditional != character else { return nil }
                        guard let fetched = DataMaster.matchFanWan(for: traditional) else { return nil }
                        return process(lexicon: fetched)
                }
        }
        private static func process(lexicon: FanWanLexicon) -> FanWanLexicon {
                let units = lexicon.units.distinct().map { unit -> FanWanUnit in
                        let homophones = DataMaster.fetchFanWanHomophones(for: unit.romanization).filter({ $0 != lexicon.word })
                        let romanization = unit.romanization
                                .replacingOccurrences(of: "7", with: "1", options: [.anchored, .backwards])
                                .replacingOccurrences(of: "8", with: "3", options: [.anchored, .backwards])
                                .replacingOccurrences(of: "9", with: "6", options: [.anchored, .backwards])
                        return FanWanUnit(word: unit.word, romanization: romanization, initial: unit.initial, final: unit.final, yamyeung: unit.yamyeung, tone: unit.tone, rhyme: unit.rhyme, interpretation: unit.interpretation, homophones: homophones)
                }
                return FanWanLexicon(word: lexicon.word, units: units)
        }
}
