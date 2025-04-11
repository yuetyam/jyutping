import Foundation
import SQLite3

struct DatabasePreparer {

        nonisolated(unsafe) private static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                guard sqlite3_open_v2(":memory:", &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                return db
        }()

        static func prepare() async {
                await withTaskGroup(of: Void.self) { group in
                        group.addTask { await createLexiconTable() }
                        group.addTask { await createT2STable() }
                        group.addTask { await createStructureTable() }
                        group.addTask { await createPinyinTable() }
                        group.addTask { await createCangjieTable() }
                        group.addTask { await createQuickTable() }
                        group.addTask { await createStrokeTable() }
                        group.addTask { await createSymbolTable() }
                        group.addTask { await createEmojiSkinMappingTable() }
                        group.addTask { await createTextMarkTable() }
                        group.addTask { await createSyllableTable() }
                        group.addTask { await createPinyinSyllableTable() }
                        await group.waitForAll()
                }
                createIndies()
                backupInMemoryDatabase()
                sqlite3_close_v2(database)
        }
        private static func backupInMemoryDatabase() {
                let path = "../CoreIME/Sources/CoreIME/Resources/imedb.sqlite3"
                if FileManager.default.fileExists(atPath: path) {
                        try? FileManager.default.removeItem(atPath: path)
                }
                var destination: OpaquePointer? = nil
                defer { sqlite3_close_v2(destination) }
                guard sqlite3_open_v2(path, &destination, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return }
                let backup = sqlite3_backup_init(destination, "main", database, "main")
                guard sqlite3_backup_step(backup, -1) == SQLITE_DONE else { return }
                guard sqlite3_backup_finish(backup) == SQLITE_OK else { return }
        }

        private static func createIndies() {
                let commands: [String] = [
                        "CREATE INDEX lexiconpingindex ON lexicontable(ping);",
                        "CREATE INDEX lexiconanchorsindex ON lexicontable(anchors);",
                        "CREATE INDEX lexiconstrictindex ON lexicontable(ping, anchors);",
                        "CREATE INDEX lexicontenkeycodeindex ON lexicontable(tenkeycode);",
                        "CREATE INDEX lexicontenkeyanchorsindex ON lexicontable(tenkeyanchors);",
                        "CREATE INDEX lexiconwordindex ON lexicontable(word);",

                        "CREATE INDEX structurepingindex ON structuretable(ping);",
                        "CREATE INDEX structuretenkeycodeindex ON structuretable(tenkeycode);",

                        "CREATE INDEX pinyinpingindex ON pinyintable(ping);",
                        "CREATE INDEX pinyinanchorsindex ON pinyintable(anchors);",
                        "CREATE INDEX pinyinstrictindex ON pinyintable(ping, anchors);",
                        "CREATE INDEX pinyintenkeycodeindex ON pinyintable(tenkeycode);",
                        "CREATE INDEX pinyintenkeyanchorsindex ON pinyintable(tenkeyanchors);",

                        "CREATE INDEX cangjiecangjie5index ON cangjietable(cangjie5);",
                        "CREATE INDEX cangjiecj5codeindex ON cangjietable(cj5code);",
                        "CREATE INDEX cangjiecangjie3index ON cangjietable(cangjie3);",
                        "CREATE INDEX cangjiecj3codeindex ON cangjietable(cj3code);",

                        "CREATE INDEX quickquick5index ON quicktable(quick5);",
                        "CREATE INDEX quickq5codeindex ON quicktable(q5code);",
                        "CREATE INDEX quickquick3index ON quicktable(quick3);",
                        "CREATE INDEX quickq3codeindex ON quicktable(q3code);",

                        "CREATE INDEX strokestrokeindex ON stroketable(stroke);",
                        "CREATE INDEX strokecodeindex ON stroketable(code);",

                        "CREATE INDEX symbolpingindex ON symboltable(ping);",
                        "CREATE INDEX symboltenkeycodeindex ON symboltable(tenkeycode);",
                        "CREATE INDEX emojiskinmappingindex ON emojiskinmapping(source);",

                        "CREATE INDEX markpingindex ON marktable(ping);",
                        "CREATE INDEX marktenkeycodeindex ON marktable(tenkeycode);",

                        "CREATE INDEX syllabletenkeyindex ON syllabletable(tenkey);"
                ]
                for command in commands {
                        var statement: OpaquePointer? = nil
                        defer { sqlite3_finalize(statement) }
                        guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(statement) == SQLITE_DONE else { return }
                }
        }

        private static func createLexiconTable() async {
                let createTable: String = "CREATE TABLE lexicontable(word TEXT NOT NULL, romanization TEXT NOT NULL, anchors INTEGER NOT NULL, ping INTEGER NOT NULL, tenkeyanchors INTEGER NOT NULL, tenkeycode INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceEntries: [LexiconEntry] = Jyutping2Lexicon.convert()
                func insert(values: String) {
                        let insert: String = "INSERT INTO lexicontable (word, romanization, anchors, ping, tenkeyanchors, tenkeycode) VALUES \(values);"
                        var insertStatement: OpaquePointer? = nil
                        defer { sqlite3_finalize(insertStatement) }
                        guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
                }
                let range: Range<Int> = 0..<2000
                let distance: Int = sourceEntries.count / 2000
                for number in range {
                        let bound: Int = (number == 1999) ? sourceEntries.count : ((number + 1) * distance)
                        let part = sourceEntries[(number * distance)..<bound]
                        let entries = part.map { entry -> String in
                                return "('\(entry.word)', '\(entry.romanization)', \(entry.anchors), \(entry.ping), \(entry.tenKeyAnchors), \(entry.tenKeyCode))"
                        }
                        let values: String = entries.joined(separator: ", ")
                        insert(values: values)
                }
        }

        private static func createT2STable() async {
                let createTable: String = "CREATE TABLE t2stable(traditional INTEGER NOT NULL PRIMARY KEY, simplified INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let entries: [String] = Hant2Hans.generate().map({ "(\($0.traditional), \($0.simplified))" })
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO t2stable (traditional, simplified) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createStructureTable() async {
                let createTable: String = "CREATE TABLE structuretable(word TEXT NOT NULL, romanization TEXT NOT NULL, ping INTEGER NOT NULL, tenkeycode INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "structure", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let word = parts[0]
                        let romanization = parts[1]
                        let syllableText = romanization.filter(\.isLetter)
                        let ping = syllableText.hash
                        let tenKeyCode = syllableText.tenKeyCharcode ?? 0
                        return "('\(word)', '\(romanization)', \(ping), \(tenKeyCode))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO structuretable (word, romanization, ping, tenkeycode) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createPinyinTable() async {
                let createTable: String = "CREATE TABLE pinyintable(word TEXT NOT NULL, romanization TEXT NOT NULL, anchors INTEGER NOT NULL, ping INTEGER NOT NULL, tenkeyanchors INTEGER NOT NULL, tenkeycode INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceEntries: [LexiconEntry] = Pinyin.process()
                func insert(values: String) {
                        let insert: String = "INSERT INTO pinyintable (word, romanization, anchors, ping, tenkeyanchors, tenkeycode) VALUES \(values);"
                        var insertStatement: OpaquePointer? = nil
                        defer { sqlite3_finalize(insertStatement) }
                        guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
                }
                let range: Range<Int> = 0..<2000
                let distance: Int = sourceEntries.count / 2000
                for number in range {
                        let bound: Int = (number == 1999) ? sourceEntries.count : ((number + 1) * distance)
                        let part = sourceEntries[(number * distance)..<bound]
                        let entries = part.map { entry -> String in
                                return "('\(entry.word)', '\(entry.romanization)', \(entry.anchors), \(entry.ping), \(entry.tenKeyAnchors), \(entry.tenKeyCode))"
                        }
                        let values: String = entries.joined(separator: ", ")
                        insert(values: values)
                }
        }
        private static func createCangjieTable() async {
                let createTable: String = "CREATE TABLE cangjietable(word TEXT NOT NULL, cangjie5 TEXT NOT NULL, cj5complex INTEGER NOT NULL, cj5code INTEGER NOT NULL, cangjie3 TEXT NOT NULL, cj3complex INTEGER NOT NULL, cj3code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceLines: [String] = Cangjie.generate()
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 7 else { return nil }
                        let word = parts[0]
                        let cangjie5 = parts[1]
                        let cj5complex = parts[2]
                        let cj5code = parts[3]
                        let cangjie3 = parts[4]
                        let cj3complex = parts[5]
                        let cj3code = parts[6]
                        return "('\(word)', '\(cangjie5)', \(cj5complex), \(cj5code), '\(cangjie3)', \(cj3complex), \(cj3code))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO cangjietable (word, cangjie5, cj5complex, cj5code, cangjie3, cj3complex, cj3code) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createQuickTable() async {
                let createTable: String = "CREATE TABLE quicktable(word TEXT NOT NULL, quick5 TEXT NOT NULL, q5complex INTEGER NOT NULL, q5code INTEGER NOT NULL, quick3 TEXT NOT NULL, q3complex INTEGER NOT NULL, q3code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceLines: [String] = Quick.generate()
                func insert(values: String) {
                        let insert: String = "INSERT INTO quicktable (word, quick5, q5complex, q5code, quick3, q3complex, q3code) VALUES \(values);"
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
                        let entries = part.compactMap { line -> String? in
                                let parts = line.split(separator: "\t")
                                guard parts.count == 7 else { return nil }
                                let word = parts[0]
                                let quick5 = parts[1]
                                let q5complex = parts[2]
                                let q5code = parts[3]
                                let quick3 = parts[4]
                                let q3complex = parts[5]
                                let q3code = parts[6]
                                return "('\(word)', '\(quick5)', \(q5complex), \(q5code), '\(quick3)', \(q3complex), \(q3code))"
                        }
                        let values: String = entries.joined(separator: ", ")
                        insert(values: values)
                }
        }
        private static func createStrokeTable() async {
                let createTable: String = "CREATE TABLE stroketable(word TEXT NOT NULL, stroke TEXT NOT NULL, complex INTEGER NOT NULL, code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceLines: [String] = Stroke.generate()
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 4 else { return nil }
                        let word = parts[0]
                        let stroke = parts[1]
                        let complex = parts[2]
                        let code = parts[3]
                        return "('\(word)', '\(stroke)', \(complex), \(code))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO stroketable (word, stroke, complex, code) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createSymbolTable() async {
                let createTable: String = "CREATE TABLE symboltable(category INTEGER NOT NULL, unicodeversion INTEGER NOT NULL, codepoint TEXT NOT NULL, cantonese TEXT NOT NULL, romanization TEXT NOT NULL, ping INTEGER NOT NULL, tenkeycode INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "symbol", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 5 else { return nil }
                        let category = parts[0]
                        let version = parts[1]
                        let codepoint = parts[2]
                        let cantonese = parts[3]
                        let romanization = parts[4]
                        let syllableText = romanization.filter(\.isLetter)
                        let ping = syllableText.hash
                        let tenKeyCode = syllableText.tenKeyCharcode ?? 0
                        return "(\(category), \(version), '\(codepoint)', '\(cantonese)', '\(romanization)', \(ping), \(tenKeyCode))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO symboltable (category, unicodeversion, codepoint, cantonese, romanization, ping, tenkeycode) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createEmojiSkinMappingTable() async {
                let createTable: String = "CREATE TABLE emojiskinmapping(source TEXT NOT NULL, target TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "skin-tone-mapping", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { line -> String? in
                        let parts = line.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let source = parts[0]
                        let target = parts[1]
                        return "('\(source)', '\(target)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO emojiskinmapping (source, target) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createTextMarkTable() async {
                let createTable: String = "CREATE TABLE marktable(mark TEXT NOT NULL, ping INTEGER NOT NULL, tenkeycode INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sources: [TextMarkLexicon] = TextMarkLexicon.convert()
                let entries = sources.map { entry -> String in
                        return "('\(entry.text)', \(entry.ping), \(entry.tenKeyCode))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO marktable (mark, ping, tenkeycode) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }

        private static func createSyllableTable() async {
                let createTable: String = "CREATE TABLE syllabletable(code INTEGER NOT NULL PRIMARY KEY, tenkey INTEGER NOT NULL, token TEXT NOT NULL, origin TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "syllable", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = content
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                        .filter({ !($0.isEmpty) })
                let entries = sourceLines.compactMap { line -> String? in
                        let parts = line.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let token = parts[0]
                        let origin = parts[1]
                        guard let code = token.charcode else { return nil }
                        guard let tenkey = token.tenKeyCharcode else { return nil }
                        return "(\(code), \(tenkey), '\(token)', '\(origin)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insertValues: String = "INSERT INTO syllabletable (code, tenkey, token, origin) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insertValues, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createPinyinSyllableTable() async {
                let createTable: String = "CREATE TABLE pinyinsyllabletable(code INTEGER NOT NULL PRIMARY KEY, syllable TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "pinyin-syllable", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = content
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .components(separatedBy: .newlines)
                        .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                        .filter({ !($0.isEmpty) })
                let entries = sourceLines.compactMap { syllable -> String? in
                        guard let code = syllable.charcode else { return nil }
                        return "(\(code), '\(syllable)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insertValues: String = "INSERT INTO pinyinsyllabletable (code, syllable) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insertValues, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
}
