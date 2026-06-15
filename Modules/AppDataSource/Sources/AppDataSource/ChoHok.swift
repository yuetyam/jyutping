import Foundation
import SQLite3
import CommonExtensions

public struct ChoHokUnit: Hashable, Identifiable {
        public let word: String
        public let romanization: String
        public let phone: String
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

// chohok_table(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, phone TEXT NOT NULL, tone TEXT NOT NULL, faancit TEXT NOT NULL);

private extension DataMaster {
        static func matchChoHok(for character: Character) -> ChoHokLexicon? {
                guard let code: UInt32 = character.unicodeScalars.first?.value else { return nil }
                let command: String = "SELECT word, romanization, phone, tone, faancit FROM chohok_table WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                var entries: [ChoHokUnit] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 1))
                        let phone: String = String(cString: sqlite3_column_text(statement, 2))
                        let tone: String = String(cString: sqlite3_column_text(statement, 3))
                        let faancit: String = String(cString: sqlite3_column_text(statement, 4))
                        let instance = ChoHokUnit(word: word, romanization: romanization, phone: phone, tone: tone, faancit: faancit, homophones: [])
                        entries.append(instance)
                }
                guard let word = entries.first?.word else { return nil }
                return ChoHokLexicon(word: word, units: entries)
        }
        static func fetchChoHokHomophones(for romanization: String) -> [String] {
                let command: String = "SELECT word FROM chohok_table WHERE romanization = ? LIMIT 11;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                guard sqlite3_bind_text(statement, 1, (romanization as NSString).utf8String, -1, DEFINED_SQLITE_TRANSIENT) == SQLITE_OK else { return [] }
                var homophones: [String] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        if let queried = sqlite3_column_text(statement, 0) {
                                homophones.append(String(cString: queried))
                        }
                }
                return homophones
        }
}

public struct ChoHok {
        public static func search(_ character: Character) -> ChoHokLexicon? {
                if let fetched = DataMaster.matchChoHok(for: character) {
                        return process(lexicon: fetched)
                } else {
                        guard let traditional = String(character).toTraditional().first else { return nil }
                        guard traditional != character else { return nil }
                        guard let fetched = DataMaster.matchChoHok(for: traditional) else { return nil }
                        return process(lexicon: fetched)
                }
        }
        private static func process(lexicon: ChoHokLexicon) -> ChoHokLexicon {
                let units = lexicon.units.distinct().map { unit -> ChoHokUnit in
                        let homophones = DataMaster.fetchChoHokHomophones(for: unit.romanization).filter({ $0 != lexicon.word })
                        return ChoHokUnit(word: unit.word, romanization: unit.romanization, phone: unit.phone, tone: unit.tone, faancit: unit.faancit, homophones: homophones)
                }
                return ChoHokLexicon(word: lexicon.word, units: units)
        }
}
