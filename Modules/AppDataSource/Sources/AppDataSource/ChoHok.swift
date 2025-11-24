import Foundation
import SQLite3
import CommonExtensions

public struct ChoHokUnit: Hashable, Identifiable {
        public let word: String
        public let romanization: String
        public let pronunciation: String
        public let tone: String
        public let faancit: String
        public let homophones: [String]
        public static func ==(lhs: ChoHokUnit, rhs: ChoHokUnit) -> Bool {
                return (lhs.word == rhs.word) && (lhs.romanization == rhs.romanization)
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(romanization)
        }
        public var id: String {
                return word + romanization
        }
}
public struct ChoHokLexicon: Hashable, Identifiable {
        public let word: String
        public let units: [ChoHokUnit]
        public static func ==(lhs: ChoHokLexicon, rhs: ChoHokLexicon) -> Bool {
                return lhs.word == rhs.word
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(word)
        }
        public let id: UUID = UUID()
}

// chohok_table(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, tone TEXT NOT NULL, faancit TEXT NOT NULL);

private extension DataMaster {
        static func matchChoHok(for character: Character) -> ChoHokLexicon? {
                guard let code: UInt32 = character.unicodeScalars.first?.value else { return nil }
                let command: String = "SELECT * FROM chohok_table WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                var entries: [ChoHokUnit] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        // let code: Int = Int(sqlite3_column_int64(queryStatement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let initial: String = String(cString: sqlite3_column_text(statement, 3))
                        let final: String = String(cString: sqlite3_column_text(statement, 4))
                        let tone: String = String(cString: sqlite3_column_text(statement, 5))
                        let faancit: String = String(cString: sqlite3_column_text(statement, 6))
                        let pronunciation: String = switch (initial == "X", final == "X") {
                        case (true, true): "?"
                        case (true, false): final
                        case (false, true): initial
                        case (false, false): initial + final
                        }
                        let faanCitText: String = faancit + "切"
                        let instance = ChoHokUnit(word: word, romanization: romanization, pronunciation: pronunciation, tone: tone, faancit: faanCitText, homophones: [])
                        entries.append(instance)
                }
                guard let word = entries.first?.word else { return nil }
                return ChoHokLexicon(word: word, units: entries)
        }
        static func fetchChoHokHomophones(for romanization: String) -> [String] {
                var homophones: [String] = []
                let query = "SELECT word FROM chohok_table WHERE romanization = '\(romanization)' LIMIT 11;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK else { return homophones }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let homophone: String = String(cString: sqlite3_column_text(statement, 0))
                        homophones.append(homophone)
                }
                return homophones
        }
}

public struct ChoHok {
        public static func search(_ character: Character) -> ChoHokLexicon? {
                if let fetched = DataMaster.matchChoHok(for: character) {
                        return process(lexicon: fetched)
                } else {
                        guard let traditional = String(character).convertedS2T().first else { return nil }
                        guard traditional != character else { return nil }
                        guard let fetched = DataMaster.matchChoHok(for: traditional) else { return nil }
                        return process(lexicon: fetched)
                }
        }
        private static func process(lexicon: ChoHokLexicon) -> ChoHokLexicon {
                let units = lexicon.units.distinct().map { unit -> ChoHokUnit in
                        let homophones = DataMaster.fetchChoHokHomophones(for: unit.romanization).filter({ $0 != lexicon.word })
                        return ChoHokUnit(word: unit.word, romanization: unit.romanization, pronunciation: unit.pronunciation, tone: unit.tone, faancit: unit.faancit, homophones: homophones)
                }
                return ChoHokLexicon(word: lexicon.word, units: units)
        }
}
