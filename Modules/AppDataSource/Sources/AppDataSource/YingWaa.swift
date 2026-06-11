import Foundation
import SQLite3
import CommonExtensions

public struct YingWaaUnit: Hashable, Identifiable {
        public let word: String
        public let romanization: String
        public let pronunciation: String
        public let note: String?
        public let interpretation: String?
        public let homophones: [String]
        public static func ==(lhs: YingWaaUnit, rhs: YingWaaUnit) -> Bool {
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
public struct YingWaaLexicon: Hashable, Identifiable {
        public let word: String
        public let units: [YingWaaUnit]
        public static func ==(lhs: YingWaaLexicon, rhs: YingWaaLexicon) -> Bool {
                return lhs.word == rhs.word
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(word)
        }
        public let id: UUID = UUID()
}

// yingwaa_table(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, pronunciation TEXT NOT NULL, note TEXT NOT NULL, interpretation TEXT NOT NULL);

private extension DataMaster {
        static func matchYingWaa(for character: Character) -> YingWaaLexicon? {
                guard let code: UInt32 = character.unicodeScalars.first?.value else { return nil }
                let command: String = "SELECT word, romanization, pronunciation, note, interpretation FROM yingwaa_table WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                var entries: [YingWaaUnit] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 1))
                        let pronunciation: String = String(cString: sqlite3_column_text(statement, 2))
                        let note: String = String(cString: sqlite3_column_text(statement, 3))
                        let interpretation: String = String(cString: sqlite3_column_text(statement, 4))
                        let mark: String? = (note == "X") ? nil : note
                        let explanation: String? = (interpretation == "X") ? nil : interpretation
                        let instance = YingWaaUnit(word: word, romanization: romanization, pronunciation: pronunciation, note: mark, interpretation: explanation, homophones: [])
                        entries.append(instance)
                }
                guard let word = entries.first?.word else { return nil }
                return YingWaaLexicon(word: word, units: entries)
        }
        static func fetchYingWaaHomophones(for romanization: String) -> [String] {
                let command: String = "SELECT word FROM yingwaa_table WHERE romanization = ? LIMIT 11;"
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

public struct YingWaa {
        public static func search(_ character: Character) -> YingWaaLexicon? {
                if let fetched = fetch(for: character) {
                        return fetched
                } else {
                        guard let traditional = String(character).toTraditional().first else { return nil }
                        guard traditional != character else { return nil }
                        return fetch(for: traditional)
                }
        }
        private static func fetch(for character: Character) -> YingWaaLexicon? {
                guard let matched = DataMaster.matchYingWaa(for: character) else { return nil }
                let romanizations = matched.units.map(\.romanization).distinct()
                let entries = romanizations.compactMap { romanization -> YingWaaUnit? in
                        let filtered = matched.units.filter({ $0.romanization == romanization })
                        guard let firstUnit = filtered.first else { return nil }
                        guard filtered.count > 1 else {
                                let homophones = DataMaster.fetchYingWaaHomophones(for: romanization).filter({ $0 != matched.word })
                                return YingWaaUnit(word: firstUnit.word, romanization: romanization, pronunciation: firstUnit.pronunciation, note: firstUnit.note, interpretation: firstUnit.interpretation, homophones: homophones)
                        }
                        let noteText: String = filtered.compactMap(\.note).distinct().joined(separator: ", ")
                        let interpretation: String = filtered.compactMap(\.interpretation).distinct().joined(separator: String.space)
                        let homophones = DataMaster.fetchYingWaaHomophones(for: romanization).filter({ $0 != matched.word })
                        return YingWaaUnit(word: firstUnit.word, romanization: romanization, pronunciation: firstUnit.pronunciation, note: noteText, interpretation: interpretation, homophones: homophones)
                }
                return YingWaaLexicon(word: matched.word, units: entries)
        }
}
