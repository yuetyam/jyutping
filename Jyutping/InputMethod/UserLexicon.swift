import Foundation
import SQLite3
import CoreIME

struct UserLexicon {

        private static var database: OpaquePointer? = nil

        private static func connect() {
                guard let libraryDirectoryUrl: URL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else { return }
                let userLexiconUrl: URL = libraryDirectoryUrl.appendingPathComponent("userlexicon.sqlite3", isDirectory: false)
                var db: OpaquePointer? = nil
                if sqlite3_open_v2(userLexiconUrl.path, &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK {
                        database = db
                        ensureTable()
                }
        }

        private static func ensureTable() {
                let createTableString = "CREATE TABLE IF NOT EXISTS lexicon(id INTEGER NOT NULL PRIMARY KEY,input INTEGER NOT NULL,ping INTEGER NOT NULL,prefix INTEGER NOT NULL,shortcut INTEGER NOT NULL,frequency INTEGER NOT NULL,word TEXT NOT NULL,jyutping TEXT NOT NULL);"
                var createTableStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
                        if sqlite3_step(createTableStatement) == SQLITE_DONE {}
                }
                sqlite3_finalize(createTableStatement)
        }

        static func close() {
                guard database != nil else { return }
                if sqlite3_close_v2(database) == SQLITE_OK {
                        database = nil
                }
        }

        static func prepare() {
                guard !isWorking else { return }
                close()
                connect()
        }

        private static var isWorking: Bool {
                guard database != nil else { return false }
                let text: String = "ngo"
                let code = text.hash
                let queryString = "SELECT word FROM lexicon WHERE ping = \(code) LIMIT 1;"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                return sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK
        }


        // MARK: - Handle Candidate

        static func handle(_ candidate: Candidate) {
                let id: Int64 = Int64((candidate.lexiconText + candidate.romanization).hash)
                if let frequency: Int64 = find(by: id) {
                        update(id: id, frequency: frequency + 1)
                } else {
                        let jyutping: String = candidate.romanization
                        let newEntry: LexiconEntry = LexiconEntry(id: id,
                                                                  input: Int64(candidate.input.hash),
                                                                  ping: jyutping.ping,
                                                                  prefix: jyutping.prefix,
                                                                  shortcut: jyutping.shortcut,
                                                                  frequency: 1,
                                                                  word: candidate.lexiconText,
                                                                  jyutping: jyutping)
                        insert(entry: newEntry)
                }
        }
        private static func find(by id: Int64) -> Int64? {
                let queryStatementString = "SELECT frequency FROM lexicon WHERE id = \(id) LIMIT 1;"
                var queryStatement: OpaquePointer? = nil
                var frequency: Int64?
                if sqlite3_prepare_v2(database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                frequency = sqlite3_column_int64(queryStatement, 0)
                        }
                }
                sqlite3_finalize(queryStatement)
                return frequency
        }
        private static func update(id: Int64, frequency: Int64) {
                let updateStatementString = "UPDATE lexicon SET frequency = \(frequency) WHERE id = \(id);"
                var updateStatement: OpaquePointer?
                if sqlite3_prepare_v2(database, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                        if sqlite3_step(updateStatement) == SQLITE_DONE {}
                }
                sqlite3_finalize(updateStatement)
        }
        private static func insert(entry: LexiconEntry) {
                let insertStatementString = "INSERT INTO lexicon (id, input, ping, prefix, shortcut, frequency, word, jyutping) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
                var insertStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {

                        sqlite3_bind_int64(insertStatement, 1, entry.id)
                        sqlite3_bind_int64(insertStatement, 2, entry.input)
                        sqlite3_bind_int64(insertStatement, 3, entry.ping)
                        sqlite3_bind_int64(insertStatement, 4, entry.prefix)
                        sqlite3_bind_int64(insertStatement, 5, entry.shortcut)
                        sqlite3_bind_int64(insertStatement, 6, entry.frequency)
                        sqlite3_bind_text(insertStatement, 7, (entry.word as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 8, (entry.jyutping as NSString).utf8String, -1, nil)

                        if sqlite3_step(insertStatement) == SQLITE_DONE {}
                }
                sqlite3_finalize(insertStatement)
        }


        // MARK: - Suggestion

        static func suggest(for text: String) -> [Candidate] {
                let matched = match(for: text)
                guard matched.isEmpty else {
                        return matched + fetch(by: text)
                }
                let convertedText: String = text.replacingOccurrences(of: "eo(ng|k)$", with: "oe$1", options: .regularExpression)
                        .replacingOccurrences(of: "oe(i|n|t)$", with: "eo$1", options: .regularExpression)
                        .replacingOccurrences(of: "eung$", with: "oeng", options: .regularExpression)
                        .replacingOccurrences(of: "(u|o)m$", with: "am", options: .regularExpression)
                        .replacingOccurrences(of: "^(ng|gw|kw|[b-z])?a$", with: "$1aa", options: .regularExpression)
                        .replacingOccurrences(of: "^y(u|un|ut)$", with: "jy$1", options: .regularExpression)
                        .replacingOccurrences(of: "y", with: "j", options: .anchored)
                return match(for: convertedText) + fetch(by: text)
        }
        private static func match(for text: String) -> [Candidate] {
                let queryStatementString = "SELECT word, jyutping FROM lexicon WHERE ping = \(text.hash) ORDER BY frequency DESC LIMIT 5;"
                var queryStatement: OpaquePointer? = nil
                var candidates: [Candidate] = []
                if sqlite3_prepare_v2(database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word = String(cString: sqlite3_column_text(queryStatement, 0))
                                let jyutping = String(cString: sqlite3_column_text(queryStatement, 1))
                                let candidate: Candidate = Candidate(text: word, romanization: jyutping, input: text, lexiconText: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        private static func fetch(by text: String) -> [Candidate] {
                let textHash: Int = text.hash
                let shortcutHash: Int = text.replacingOccurrences(of: "y", with: "j").hash
                let queryStatementString = "SELECT word, jyutping FROM lexicon WHERE input = \(textHash) OR prefix = \(textHash) OR shortcut = \(shortcutHash) ORDER BY frequency DESC LIMIT 5;"
                var queryStatement: OpaquePointer? = nil
                var candidates: [Candidate] = []
                if sqlite3_prepare_v2(database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word = String(cString: sqlite3_column_text(queryStatement, 0))
                                let jyutping = String(cString: sqlite3_column_text(queryStatement, 1))
                                let candidate: Candidate = Candidate(text: word, romanization: jyutping, input: text, lexiconText: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }

        /// Delete one lexicon entry
        static func removeItem(candidate: Candidate) {
                let id: Int64 = Int64((candidate.lexiconText + candidate.romanization).hash)
                let deleteStatementString = "DELETE FROM lexicon WHERE id = \(id) LIMIT 1;"
                var deleteStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                        if sqlite3_step(deleteStatement) == SQLITE_DONE {}
                }
                sqlite3_finalize(deleteStatement)
        }

        /// Clear User Lexicon
        static func deleteAll() {
                let deleteStatementString = "DELETE FROM lexicon;"
                var deleteStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(database, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                        if sqlite3_step(deleteStatement) == SQLITE_DONE {}
                }
                sqlite3_finalize(deleteStatement)
        }
}

private struct LexiconEntry {

        /// (Candidate.lexiconText + Candidate.jyutping).hash
        let id: Int64

        /// input.hash
        let input: Int64

        /// jyutping.withoutTonesAndSpaces.hash
        let ping: Int64

        /// jyutping.prefix.hash
        let prefix: Int64

        /// jyutping.initials.hash
        let shortcut: Int64

        let frequency: Int64

        /// Candidate.lexiconText
        let word: String

        let jyutping: String
}
