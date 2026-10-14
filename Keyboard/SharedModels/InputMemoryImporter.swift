import Foundation
import CommonExtensions
import SQLiteWrapper

enum InputMemoryImportError: Error, Equatable {
        case unsupportedFormat
}

/// Imports a version-1 portable export (see `InputMemoryExporter`) into the live `memory2608` table.
enum InputMemoryImporter {

        /// Existing entries keep the larger frequency and the later timestamp, so importing the same file again changes nothing.
        private static let upsertCommand: String = "INSERT INTO memory2608 (word, romanization, frequency, latest, char_count, letter_count, complexity, anchors, spell, anchors_9key, spell_9key) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON CONFLICT (word, romanization) DO UPDATE SET frequency = MAX(frequency, excluded.frequency), latest = MAX(latest, excluded.latest);"

        /// Capture and validate a private snapshot of the selected file, then merge its valid entries in one transaction.
        /// - Returns: The number of merged entries. Rows with invalid values are skipped.
        static func importEntries(from file: URL, into store: URL, timeout: Duration = .seconds(10)) throws -> Int64 {
                try Task.checkCancellation()
                let workspace = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
                try FileManager.default.createDirectory(at: workspace, withIntermediateDirectories: false)
                defer { try? FileManager.default.removeItem(at: workspace) }
                let snapshot = workspace.appendingPathComponent("import.sqlite3")
                do {
                        try capture(file: file, snapshot: snapshot, timeout: timeout)
                        try validate(snapshot: snapshot)
                } catch let error as SQLiteError where error != .timedOut {
                        throw InputMemoryImportError.unsupportedFormat
                }
                return try merge(snapshot: snapshot, store: store)
        }

        private static func capture(file: URL, snapshot: URL, timeout: Duration) throws {
                let fileDB = try SQLiteDatabase(url: file, flags: [.readOnly, .fullMutex])
                let snapshotDB = try SQLiteDatabase(url: snapshot, flags: [.readWrite, .create, .fullMutex])
                try fileDB.backup(to: snapshotDB, pagesPerStep: 128, timeout: timeout)
                try snapshotDB.execute("PRAGMA journal_mode = DELETE;")
                try snapshotDB.close()
                try fileDB.close()
        }

        /// Version-1 readers accept the four exported columns, with or without the optional indexes.
        private static func validate(snapshot: URL) throws {
                try Task.checkCancellation()
                let db = try SQLiteDatabase(url: snapshot, flags: [.readOnly, .fullMutex])
                guard try db.userVersion() == 1, try db.tableExists("input_memory") else { throw InputMemoryImportError.unsupportedFormat }
                guard try db.integer("SELECT COUNT(*) FROM pragma_table_info('input_memory') WHERE name IN ('word', 'romanization', 'frequency', 'latest');") == 4 else { throw InputMemoryImportError.unsupportedFormat }
                guard try db.isIntegrityOK() else { throw InputMemoryImportError.unsupportedFormat }
                try db.close()
        }

        private static func merge(snapshot: URL, store: URL) throws -> Int64 {
                let snapshotDB = try SQLiteDatabase(url: snapshot, flags: [.readOnly, .fullMutex])
                // The store must already be prepared; never create a new one here.
                let storeDB = try SQLiteDatabase(url: store, flags: [.readWrite, .fullMutex])
                try storeDB.setBusyTimeout(milliseconds: 5000)
                let count: Int64 = try storeDB.transaction(.immediate) {
                        let query = try snapshotDB.prepare("SELECT word, romanization, frequency, latest FROM input_memory;")
                        let upsert = try storeDB.prepare(upsertCommand)
                        var count: Int64 = 0
                        while try query.step() {
                                try Task.checkCancellation()
                                guard let entry = entry(from: query) else { continue }
                                try upsert.run(entry.word, entry.romanization, entry.frequency, entry.latest, entry.charCount, entry.letterCount, entry.complexity, entry.anchors, entry.spell, entry.nineKeyAnchors, entry.nineKeySpell)
                                count += 1
                        }
                        try Task.checkCancellation()
                        return count
                }
                try storeDB.close()
                try snapshotDB.close()
                return count
        }

        private static func entry(from row: SQLiteStatement) -> MemoryLexicon? {
                guard let word = try? row.requireText(at: 0), let romanization = try? row.requireText(at: 1), let frequency = try? row.requireInt64(at: 2), let latest = try? row.requireInt64(at: 3) else { return nil }
                guard word.isNotEmpty, frequency > 0, latest > 0, isValidRomanization(romanization) else { return nil }
                return MemoryLexicon(word: word, romanization: romanization, frequency: frequency, latest: latest)
        }

        /// Jyutping syllables: lowercase basic Latin letters, optional tone digits, separated by spaces.
        private static func isValidRomanization(_ text: String) -> Bool {
                return text.contains(where: \.isLowercaseBasicLatinLetter) && text.allSatisfy({ $0.isLowercaseBasicLatinLetter || $0.isCantoneseToneDigit || $0.isSpace })
        }
}
