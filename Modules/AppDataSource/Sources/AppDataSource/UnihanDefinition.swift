import Foundation
import SQLite3

public struct UnihanDefinition: Hashable {

        public let character: Character
        public let definition: String

        public static func match<T: StringProtocol>(text: T) -> UnihanDefinition? {
                guard text.count == 1 else { return nil }
                guard let character = text.first else { return nil }
                guard let code = character.unicodeScalars.first?.value else { return nil }
                guard let definition = DataMaster.matchDefinition(for: code) else { return nil }
                return UnihanDefinition(character: character, definition: definition)
        }
}

private extension DataMaster {
        static func matchDefinition(for code: UInt32) -> String? {
                let command: String = "SELECT definition FROM definitiontable WHERE code = \(code) LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                let definition: String = String(cString: sqlite3_column_text(statement, 0))
                return definition
        }
}
