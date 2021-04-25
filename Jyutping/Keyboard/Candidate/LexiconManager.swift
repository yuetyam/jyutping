import Foundation
import SQLite3

struct LexiconManager {
        
        private var userdb: OpaquePointer? = {
                guard let libraryDirectoryUrl: URL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else { return nil }
                let userdbUrl: URL = libraryDirectoryUrl.appendingPathComponent("userdb.sqlite3", isDirectory: false)
                var db: OpaquePointer? = nil
                if sqlite3_open_v2(userdbUrl.path, &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK {
                        return db
                } else {
                        debugPrint("sqlite3_open_v2 failed.")
                        debugPrint(userdbUrl)
                        return nil
                }
        }()
        func close() {
                sqlite3_close_v2(userdb)
        }
        
        init() {
                ensureTable()
        }
        
        private func ensureTable() {
                // id = (candidate.input + candidate.lexiconText + candidate.jyutping).hash
                // token = candidate.input.hash
                // shortcut = candidate.jyutping.shortcut = candidate.jyutping.initials.hash
                let createTableString = "CREATE TABLE IF NOT EXISTS lexicon(id INTEGER NOT NULL PRIMARY KEY,token INTEGER NOT NULL,shortcut INTEGER NOT NULL,frequency INTEGER NOT NULL,word TEXT NOT NULL,jyutping TEXT NOT NULL);"
                var createTableStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(userdb, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
                        if sqlite3_step(createTableStatement) != SQLITE_DONE {
                                consolePrint("User lexicon table could not be created.")
                        }
                } else {
                        consolePrint("CREATE TABLE statement could not be prepared.")
                }
                sqlite3_finalize(createTableStatement)
        }
        
        func handle(_ candidate: Candidate) {
                let id: Int64 = Int64((candidate.input + candidate.lexiconText + candidate.jyutping).hash)
                if let existingFrequency: Int64 = find(by: id) {
                        update(id: id, frequency: existingFrequency + 1)
                } else {
                        let newEntry: Entry = Entry(id: id,
                                                    token: Int64(candidate.input.hash),
                                                    shortcut: candidate.jyutping.shortcut,
                                                    frequency: 1,
                                                    word: candidate.lexiconText,
                                                    jyutping: candidate.jyutping)
                        insert(entry: newEntry)
                }
        }
        
        private func insert(entry: Entry) {
                let insertStatementString = "INSERT INTO lexicon (id, token, shortcut, frequency, word, jyutping) VALUES (?, ?, ?, ?, ?, ?);"
                var insertStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(userdb, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                        
                        sqlite3_bind_int64(insertStatement, 1, entry.id)
                        sqlite3_bind_int64(insertStatement, 2, entry.token)
                        sqlite3_bind_int64(insertStatement, 3, entry.shortcut)
                        sqlite3_bind_int64(insertStatement, 4, entry.frequency)
                        sqlite3_bind_text(insertStatement, 5, (entry.word as NSString).utf8String, -1, nil)
                        sqlite3_bind_text(insertStatement, 6, (entry.jyutping as NSString).utf8String, -1, nil)
                        
                        if sqlite3_step(insertStatement) != SQLITE_DONE {
                                consolePrint("Could not insert row.")
                        }
                } else {
                        consolePrint("INSERT statement could not be prepared.")
                }
                sqlite3_finalize(insertStatement)
        }
        
        private func update(id: Int64, frequency: Int64) {
                let updateStatementString = "UPDATE lexicon SET frequency = \(frequency) WHERE id = \(id);"
                var updateStatement: OpaquePointer?
                if sqlite3_prepare_v2(userdb, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                        if sqlite3_step(updateStatement) != SQLITE_DONE {
                                consolePrint("Could not update row.")
                        }
                } else {
                        consolePrint("UPDATE statement is not prepared.")
                }
                sqlite3_finalize(updateStatement)
        }

        private func find(by id: Int64) -> Int64? {
                let queryStatementString = "SELECT frequency FROM lexicon WHERE id = \(id) LIMIT 1;"
                var queryStatement: OpaquePointer? = nil
                var frequency: Int64?
                if sqlite3_prepare_v2(userdb, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                frequency = sqlite3_column_int64(queryStatement, 0)
                        }
                } else {
                        consolePrint("SELECT statement could not be prepared.")
                }
                sqlite3_finalize(queryStatement)
                return frequency
        }
        
        func suggest(for text: String) -> [Candidate] {
                let textHash: Int = text.hash
                let queryStatementString = "SELECT word, jyutping FROM lexicon WHERE token = \(textHash) OR shortcut = \(textHash) ORDER BY frequency DESC LIMIT 5;"
                var queryStatement: OpaquePointer? = nil
                var candidates: [Candidate] = []
                if sqlite3_prepare_v2(userdb, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                                let jyutping = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                                let candidate: Candidate = Candidate(text: word, jyutping: jyutping, input: text, lexiconText: word)
                                candidates.append(candidate)
                        }
                } else {
                        consolePrint("SELECT statement could not be prepared.")
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        
        func deleteAll() {
                let deleteStatementStirng = "DELETE FROM lexicon;"
                var deleteStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(userdb, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
                        if sqlite3_step(deleteStatement) != SQLITE_DONE {
                                consolePrint("Could not delete all rows.")
                        }
                } else {
                        consolePrint("DELETE ALL statement could not be prepared.")
                }
                sqlite3_finalize(deleteStatement)
        }
        
        private func consolePrint(_ text: String) {
                #if DEBUG
                debugPrint(text)
                #endif
        }

        func fetchAll() -> [LexiconEntry] {
                var entries: [LexiconEntry] = []
                let queryStatementString = "SELECT * FROM lexicon;"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(userdb, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                // let id = sqlite3_column_int64(queryStatement, 0)
                                let token = sqlite3_column_int64(queryStatement, 1)
                                // let shortcut = sqlite3_column_int64(queryStatement, 2)
                                let frequency = sqlite3_column_int64(queryStatement, 3)
                                let word = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                                let jyutping = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))

                                let id = Int64((word + jyutping).hash)
                                let lexiconEntry: LexiconEntry = LexiconEntry(id: id,
                                                                              input: token,
                                                                              ping: jyutping.ping,
                                                                              prefix: jyutping.prefix,
                                                                              shortcut: jyutping.shortcut,
                                                                              frequency: frequency,
                                                                              word: word,
                                                                              jyutping: jyutping)
                                entries.append(lexiconEntry)
                        }
                }
                sqlite3_finalize(queryStatement)
                return entries
        }
}
