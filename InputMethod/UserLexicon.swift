import Foundation
import SQLite3
import CoreIME
import CommonExtensions

struct UserLexicon {

        nonisolated(unsafe) private static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                let path: String? = {
                        let fileName: String = "userlexicon.sqlite3"
                        if #available(macOS 13.0, *) {
                                return URL.libraryDirectory.appending(path: fileName, directoryHint: .notDirectory).path()
                        } else {
                                guard let libraryDirectoryUrl: URL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else { return nil }
                                return libraryDirectoryUrl.appendingPathComponent(fileName, isDirectory: false).path
                        }
                }()
                guard let path else { return nil }
                guard sqlite3_open_v2(path, &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                return db
        }()

        static func prepare() {
                let command: String = "CREATE TABLE IF NOT EXISTS lexicon(id INTEGER NOT NULL PRIMARY KEY,input INTEGER NOT NULL,ping INTEGER NOT NULL,prefix INTEGER NOT NULL,shortcut INTEGER NOT NULL,frequency INTEGER NOT NULL,word TEXT NOT NULL,jyutping TEXT NOT NULL);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }

        static func handle(_ candidate: Candidate?) {
                guard let candidate else { return }
                let id: Int = (candidate.lexiconText + candidate.romanization).hash
                if let frequency = find(by: id) {
                        update(id: id, frequency: frequency + 1)
                } else {
                        let romanization: String = candidate.romanization
                        let entry = LexiconEntry(
                                id: id,
                                input: candidate.input.hash,
                                ping: romanization.ping,
                                prefix: romanization.shortcut,
                                shortcut: romanization.shortcut,
                                frequency: 1,
                                word: candidate.lexiconText,
                                jyutping: romanization
                        )
                        insert(entry: entry)
                }
        }
        private static func find(by id: Int) -> Int64? {
                let command: String = "SELECT frequency FROM lexicon WHERE id = \(id) LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                let frequency: Int64 = sqlite3_column_int64(statement, 0)
                return frequency
        }
        private static func update(id: Int, frequency: Int64) {
                let command: String = "UPDATE lexicon SET frequency = \(frequency) WHERE id = \(id);"
                var statement: OpaquePointer?
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func insert(entry: LexiconEntry) {
                // INSERT INTO lexicon (id, input, ping, prefix, shortcut, frequency, word, jyutping) VALUES (?, ?, ?, ?, ?, ?, ?, ?);
                let leading: String = "INSERT INTO lexicon (id, input, ping, prefix, shortcut, frequency, word, jyutping) VALUES ("
                let trailing: String = ");"
                let values: String = "\(entry.id), \(entry.input), \(entry.ping), \(entry.prefix), \(entry.shortcut), \(entry.frequency), '\(entry.word)', '\(entry.jyutping)'"
                let command: String = leading + values + trailing
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }

        static func suggest(text: String, segmentation: Segmentation) -> [Candidate] {
                let matches = query(text: text, input: text, isShortcut: false)
                let shortcuts = query(text: text, input: text, mark: text.spaceSeparated(), isShortcut: true)
                let searches: [Candidate] = {
                        let textCount = text.count
                        let schemes = segmentation.filter({ $0.length == textCount })
                        guard schemes.isNotEmpty else { return [] }
                        return schemes.map({ scheme -> [Candidate] in
                                let pingText = scheme.map(\.origin).joined()
                                let matched = query(text: pingText, input: text, isShortcut: false)
                                guard matched.isNotEmpty else { return [] }
                                let text2mark = scheme.map(\.text).joined(separator: String.space)
                                let syllables = scheme.map(\.origin).joined(separator: String.space)
                                return matched.compactMap({ item -> Candidate? in
                                        guard item.mark == syllables else { return nil }
                                        return Candidate(text: item.text, romanization: item.romanization, input: item.input, mark: text2mark, order: -1)
                                })
                        }).flatMap({ $0 })
                }()
                return matches + shortcuts + searches
        }
        private static func query(text: String, input: String, mark: String? = nil, isShortcut: Bool) -> [Candidate] {
                var candidates: [Candidate] = []
                let code: Int = isShortcut ? text.replacingOccurrences(of: "y", with: "j").hash : text.hash
                let column: String = isShortcut ? "shortcut" : "ping"
                let command: String = "SELECT word, jyutping FROM lexicon WHERE \(column) = \(code) ORDER BY frequency DESC LIMIT 5;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return candidates }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word = String(cString: sqlite3_column_text(statement, 0))
                        let jyutping = String(cString: sqlite3_column_text(statement, 1))
                        let mark: String = mark ?? jyutping.removedTones()
                        let candidate: Candidate = Candidate(text: word, romanization: jyutping, input: input, mark: mark, order: -1)
                        candidates.append(candidate)
                }
                return candidates
        }

        /// Delete one lexicon entry
        static func removeItem(candidate: Candidate) {
                let id: Int = (candidate.lexiconText + candidate.romanization).hash
                let command: String = "DELETE FROM lexicon WHERE id = \(id) LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }

        /// Clear User Lexicon
        static func deleteAll() {
                let command: String = "DELETE FROM lexicon;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
}

private struct LexiconEntry {

        /// (Candidate.lexiconText + Candidate.jyutping).hash
        let id: Int

        /// input.hash
        let input: Int

        /// jyutping.withoutTonesAndSpaces.hash
        let ping: Int

        /// (deprecated)
        let prefix: Int

        /// jyutping.anchors.hash
        let shortcut: Int

        let frequency: Int

        /// Candidate.lexiconText
        let word: String

        let jyutping: String
}
