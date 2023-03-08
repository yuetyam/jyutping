import Foundation
import SQLite3

public struct Engine {

        private static var dbPath: String? {
                guard let cacheUrl = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
                let url = cacheUrl.appendingPathComponent("imedb.sqlite3", isDirectory: false)
                return url.path
        }

        private(set) static var database: OpaquePointer? = nil
        private(set) static var cachedDatabase: OpaquePointer? = nil
        private(set) static var isDatabaseReady: Bool = false

        public static func prepare(appVersion: String) {
                guard !isDatabaseReady else { return }
                guard !verifiedCachedDatabase(appVersion: appVersion) else {
                        #if os(macOS)
                        loadCachedDatabaseIntoMemory()
                        #endif
                        isDatabaseReady = true
                        return
                }
                sqlite3_close_v2(database)
                sqlite3_close_v2(cachedDatabase)
                #if os(macOS)
                guard sqlite3_open_v2(":memory:", &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                #else
                guard let path: String = dbPath else { return }
                try? FileManager.default.removeItem(atPath: path)
                guard sqlite3_open_v2(path, &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                #endif
                createLexiconTable()
                createT2STable()
                createComposeTable()
                createPinyinTable()
                createShapeTable()
                createEmojiTable()
                createMetaTable(appVersion: appVersion)
                isDatabaseReady = true
                createIndies()
                #if os(macOS)
                backupInMemoryDatabaseToCaches()
                #endif
        }
        private static func verifiedCachedDatabase(appVersion: String) -> Bool {
                guard let path = dbPath else { return false }
                guard FileManager.default.fileExists(atPath: path) else { return false }
                #if os(macOS)
                guard sqlite3_open_v2(path, &cachedDatabase, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else { return false }
                #else
                guard sqlite3_open_v2(path, &database, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else { return false }
                #endif
                let query: String = "SELECT valuetext FROM metatable WHERE keynumber = 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                #if os(macOS)
                guard sqlite3_prepare_v2(cachedDatabase, query, -1, &statement, nil) == SQLITE_OK else { return false }
                #else
                guard sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK else { return false }
                #endif
                guard sqlite3_step(statement) == SQLITE_ROW else { return false }
                let savedAppVersion: String = String(cString: sqlite3_column_text(statement, 0))
                return appVersion == savedAppVersion
        }
        private static func backupInMemoryDatabaseToCaches() {
                guard let path = dbPath else { return }
                try? FileManager.default.removeItem(atPath: path)
                var destination: OpaquePointer? = nil
                defer { sqlite3_close_v2(destination) }
                guard sqlite3_open_v2(path, &destination, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                let backup = sqlite3_backup_init(destination, "main", database, "main")
                guard sqlite3_backup_step(backup, -1) == SQLITE_DONE else { return }
                guard sqlite3_backup_finish(backup) == SQLITE_OK else { return }
        }
        private static func loadCachedDatabaseIntoMemory() {
                guard sqlite3_open_v2(":memory:", &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                let backup = sqlite3_backup_init(database, "main", cachedDatabase, "main")
                guard sqlite3_backup_step(backup, -1) == SQLITE_DONE else { return }
                guard sqlite3_backup_finish(backup) == SQLITE_OK else { return }
                sqlite3_close_v2(cachedDatabase)
        }
}

private extension Engine {
        static func createMetaTable(appVersion: String) {
                let createTable: String = "CREATE TABLE metatable(keynumber INTEGER NOT NULL PRIMARY KEY, valuetext TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let values: String = "(1, '\(appVersion)')"
                let insert: String = "INSERT INTO metatable (keynumber, valuetext) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        static func createLexiconTable() {
                let createTable: String = "CREATE TABLE lexicontable(word TEXT NOT NULL, romanization TEXT NOT NULL, shortcut INTEGER NOT NULL, ping INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "lexicon", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                func insert(values: String) {
                        let insert: String = "INSERT INTO lexicontable (word, romanization, shortcut, ping) VALUES \(values);"
                        var insertStatement: OpaquePointer? = nil
                        defer { sqlite3_finalize(insertStatement) }
                        guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
                }
                let range: Range<Int> = 0..<2000
                let distance: Int = sourceLines.count / 2000
                for number in range {
                        let bound: Int = number == 1999 ? sourceLines.count : ((number + 1) * distance)
                        let part = sourceLines[(number * distance)..<bound]
                        let entries = part.map { line -> String? in
                                let parts = line.split(separator: "\t")
                                guard parts.count == 4 else { return nil }
                                let word = parts[0]
                                let romanization = parts[1]
                                let shortcut = parts[2]
                                let ping = parts[3]
                                return "('\(word)', '\(romanization)', \(shortcut), \(ping))"
                        }
                        let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                        insert(values: values)
                }
        }
        static func createIndies() {
                let commands: [String] = [
                        "CREATE INDEX lexiconpingindex ON lexicontable(ping);",
                        "CREATE INDEX lexiconshortcutindex ON lexicontable(shortcut);",
                        "CREATE INDEX lexiconwordindex ON lexicontable(word);",
                        "CREATE INDEX composepingindex ON composetable(ping);",
                        "CREATE INDEX pinyinshortcutindex ON pinyintable(shortcut);",
                        "CREATE INDEX pinyinpinindex ON pinyintable(pin);",
                        "CREATE INDEX shapecangjieindex ON shapetable(cangjie);",
                        "CREATE INDEX shapestrokeindex ON shapetable(stroke);",
                        "CREATE INDEX emojipingindex ON emojitable(ping);"
                ]
                for command in commands {
                        var statement: OpaquePointer? = nil
                        guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { sqlite3_finalize(statement); return }
                        guard sqlite3_step(statement) == SQLITE_DONE else { sqlite3_finalize(statement); return }
                        sqlite3_finalize(statement)
                }
        }
}

private extension Engine {
        static func createT2STable() {
                let createTable: String = "CREATE TABLE t2stable(traditional INTEGER NOT NULL PRIMARY KEY, simplified TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "t2s", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.map { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let traditionalCode = parts[0]
                        let simplified = parts[1]
                        return "(\(traditionalCode), '\(simplified)')"
                }
                let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                let insert: String = "INSERT INTO t2stable (traditional, simplified) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        static func createComposeTable() {
                let createTable: String = "CREATE TABLE composetable(word TEXT NOT NULL, romanization TEXT NOT NULL, ping INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "compose", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.map { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 3 else { return nil }
                        let word = parts[0]
                        let romanization = parts[1]
                        let ping = parts[2]
                        return "('\(word)', '\(romanization)', \(ping))"
                }
                let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                let insert: String = "INSERT INTO composetable (word, romanization, ping) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        static func createPinyinTable() {
                let createTable: String = "CREATE TABLE pinyintable(word TEXT NOT NULL, shortcut INTEGER NOT NULL, pin INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "pinyin", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                func insert(values: String) {
                        let insert: String = "INSERT INTO pinyintable (word, shortcut, pin) VALUES \(values);"
                        var insertStatement: OpaquePointer? = nil
                        defer { sqlite3_finalize(insertStatement) }
                        guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
                }
                let range: Range<Int> = 0..<2000
                let distance: Int = sourceLines.count / 2000
                for number in range {
                        let bound: Int = number == 1999 ? sourceLines.count : ((number + 1) * distance)
                        let part = sourceLines[(number * distance)..<bound]
                        let entries = part.map { line -> String? in
                                // TODO: replace , with tab
                                let parts = line.split(separator: ",")
                                guard parts.count == 4 else { return nil }
                                let word = parts[0]
                                let pin = parts[1]
                                let shortcut = parts[2]
                                return "('\(word)', \(shortcut), \(pin))"
                        }
                        let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                        insert(values: values)
                }
        }
        static func createShapeTable() {
                let createTable: String = "CREATE TABLE shapetable(word TEXT NOT NULL, cangjie TEXT NOT NULL, stroke TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "shape", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.map { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 3 else { return nil }
                        let word = parts[0]
                        let cangjie = parts[1]
                        let stroke = parts[2]
                        return "('\(word)', '\(cangjie)', '\(stroke)')"
                }
                let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                let insert: String = "INSERT INTO shapetable (word, cangjie, stroke) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        static func createEmojiTable() {
                let createTable: String = "CREATE TABLE emojitable(emoji TEXT NOT NULL, cantonese TEXT NOT NULL, romanization TEXT NOT NULL, ping INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "emoji", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.map { sourceLine -> String? in
                        // TODO: replace , with tab
                        let parts = sourceLine.split(separator: ",")
                        guard parts.count == 4 else { return nil }
                        let word = parts[0]
                        let cantonese = parts[1]
                        let romanization = parts[2]
                        let ping = parts[3]
                        return "('\(word)', '\(cantonese)', '\(romanization)', \(ping))"
                }
                let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                let insert: String = "INSERT INTO emojitable (emoji, cantonese, romanization, ping) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
}


extension Engine {

        public static func searchEmojis(for text: String) -> [Candidate] {
                guard Engine.isDatabaseReady else { return [] }
                let regularMatch = matchEmojis(for: text)
                guard regularMatch.isEmpty else { return regularMatch }
                let convertedText: String = text.replacingOccurrences(of: "eo(ng|k)$", with: "oe$1", options: .regularExpression)
                        .replacingOccurrences(of: "oe(i|n|t)$", with: "eo$1", options: .regularExpression)
                        .replacingOccurrences(of: "eung$", with: "oeng", options: .regularExpression)
                        .replacingOccurrences(of: "(u|o)m$", with: "am", options: .regularExpression)
                        .replacingOccurrences(of: "^(ng|gw|kw|[b-z])?a$", with: "$1aa", options: .regularExpression)
                        .replacingOccurrences(of: "^y(u|un|ut)$", with: "jy$1", options: .regularExpression)
                        .replacingOccurrences(of: "y", with: "j", options: .anchored)
                return matchEmojis(for: convertedText)
        }

        private static func matchEmojis(for text: String) -> [Candidate] {
                var candidates: [Candidate] = []
                let queryString = "SELECT emoji, cantonese, romanization FROM emojitable WHERE ping = \(text.hash);"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let emojiCodeText: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let cantonese: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 2))
                                if let emoji: String = transform(codes: emojiCodeText) {
                                        let instance = Candidate(emoji: emoji, cantonese: cantonese, romanization: romanization, input: text)
                                        candidates.append(instance)
                                }
                        }
                }
                return candidates
        }

        private static func transform(codes: String) -> String? {
                let blocks: [String] = codes.components(separatedBy: ".")
                switch blocks.count {
                case 0, 1:
                        guard let character = character(from: codes) else { return nil }
                        return String(character)
                default:
                        let characters = blocks.map({ character(from: $0) })
                        let found = characters.compactMap({ $0 })
                        guard found.count == characters.count else { return nil }
                        return String(found)
                }
        }

        /// Create a Character from the given Unicode Code Point String, e.g. 1F600
        private static func character(from codePoint: String) -> Character? {
                guard let u32 = UInt32(codePoint, radix: 16) else { return nil }
                guard let scalar = Unicode.Scalar(u32) else { return nil }
                return Character(scalar)
        }
}


extension Engine {


        /// Search special mark for text
        /// - Parameter text: Input text
        /// - Returns: Candidate, type == .specialMark
        public static func searchMark(for text: String) -> Candidate? {
                let key: String = text.lowercased()
                guard let markText = specialMarks[key] else { return nil }
                return Candidate(mark: markText)
        }

        private static let specialMarks: [String: String] = {
                let values: [String] = [
                        "iOS",
                        "iPadOS",
                        "macOS",
                        "watchOS",
                        "tvOS",
                        "iPhone",
                        "iPad",
                        "iPod",
                        "iMac",
                        "MacBook",
                        "HomePod",
                        "AirPods",
                        "AirTag",
                        "iCloud",
                        "FaceTime",
                        "iMessage",
                        "SwiftUI",
                        "GitHub",
                        "PayPal",
                        "WhatsApp",
                        "YouTube",
                        "Canton",
                        "Cantonese",
                        "Cantonia"
                ]
                let keys: [String] = values.map({ $0.lowercased() })
                let dict: [String: String] = Dictionary(uniqueKeysWithValues: zip(keys, values))
                return dict
        }()
}

