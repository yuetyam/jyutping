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
                        "CREATE INDEX cangjiec5codeindex ON cangjietable(c5code);",
                        "CREATE INDEX cangjiecangjie3index ON cangjietable(cangjie3);",
                        "CREATE INDEX cangjiec3codeindex ON cangjietable(c3code);",

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

                        "CREATE INDEX syllabletenkeyindex ON syllabletable(tenkeyaliascode);",
                        "CREATE INDEX pinyinsyllabletenkeyindex ON pinyinsyllabletable(tenkeycode);"
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
                let sourceEntries: [LexiconEntry] = LexiconConverter.jyutping()
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
                let sourceEntries: [LexiconEntry] = LexiconConverter.structure()
                let entries = sourceEntries.map { entry -> String in
                        return "('\(entry.word)', '\(entry.romanization)', \(entry.ping), \(entry.tenKeyCode))"
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
                let sourceEntries: [LexiconEntry] = LexiconConverter.pinyin()
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
                let createTable: String = "CREATE TABLE cangjietable(word TEXT NOT NULL, cangjie5 TEXT NOT NULL, c5complex INTEGER NOT NULL, c5code INTEGER NOT NULL, cangjie3 TEXT NOT NULL, c3complex INTEGER NOT NULL, c3code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceEntries = Cangjie.generate()
                let entries = sourceEntries.map { entry -> String in
                        return "('\(entry.word)', '\(entry.cangjie5)', \(entry.c5complex), \(entry.c5code), '\(entry.cangjie3)', \(entry.c3complex), \(entry.c3code))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO cangjietable (word, cangjie5, c5complex, c5code, cangjie3, c3complex, c3code) VALUES \(values);"
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
                let sourceEntries = Quick.generate()
                func insert(values: String) {
                        let insert: String = "INSERT INTO quicktable (word, quick5, q5complex, q5code, quick3, q3complex, q3code) VALUES \(values);"
                        var insertStatement: OpaquePointer? = nil
                        defer { sqlite3_finalize(insertStatement) }
                        guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
                }
                let range: Range<Int> = 0..<2000
                let distance: Int = sourceEntries.count / 2000
                for number in range {
                        let bound: Int = number == 1999 ? sourceEntries.count : ((number + 1) * distance)
                        let part = sourceEntries[(number * distance)..<bound]
                        let entries = part.map { entry -> String in
                                return "('\(entry.word)', '\(entry.quick5)', \(entry.q5complex), \(entry.q5code), '\(entry.quick3)', \(entry.q3complex), \(entry.q3code))"
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
                let sourceEntries = Stroke.generate()
                let entries = sourceEntries.map { entry -> String in
                        return "('\(entry.word)', '\(entry.stroke)', \(entry.complex), \(entry.code))"
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
                        let codePoint = parts[2]
                        let cantonese = parts[3]
                        let romanization = parts[4]
                        let syllableText = romanization.filter(\.isLowercaseBasicLatinLetter)
                        let pingCode = syllableText.hash
                        let tenKeyCode = syllableText.tenKeyCharCode ?? 0
                        return "(\(category), \(version), '\(codePoint)', '\(cantonese)', '\(romanization)', \(pingCode), \(tenKeyCode))"
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
                let createTable: String = "CREATE TABLE syllabletable(aliascode INTEGER NOT NULL PRIMARY KEY, origincode INTEGER NOT NULL, tenkeyaliascode INTEGER NOT NULL, tenkeyorigincode INTEGER NOT NULL, alias TEXT NOT NULL, origin TEXT NOT NULL);"
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
                        .filter(\.isNotEmpty)
                let entries = sourceLines.compactMap { line -> String? in
                        lazy var errorMessage: String = "syllable.txt : bad format : \(line)"
                        let parts = line.split(separator: "\t")
                        guard parts.count == 2 else { fatalError(errorMessage) }
                        let alias = parts[0]
                        let origin = parts[1]
                        guard let aliasCode = alias.charCode, aliasCode > 0 else { fatalError(errorMessage) }
                        guard let originCode = origin.charCode, originCode > 0 else { fatalError(errorMessage) }
                        guard let tenKeyAliasCode = alias.tenKeyCharCode, tenKeyAliasCode > 0 else { fatalError(errorMessage) }
                        guard let tenKeyOriginCode = origin.tenKeyCharCode, tenKeyOriginCode > 0 else { fatalError(errorMessage) }
                        return "(\(aliasCode), \(originCode), \(tenKeyAliasCode), \(tenKeyOriginCode), '\(alias)', '\(origin)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insertValues: String = "INSERT INTO syllabletable (aliascode, origincode, tenkeyaliascode, tenkeyorigincode, alias, origin) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insertValues, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createPinyinSyllableTable() async {
                let createTable: String = "CREATE TABLE pinyinsyllabletable(code INTEGER NOT NULL PRIMARY KEY, tenkeycode INTEGER NOT NULL, syllable TEXT NOT NULL);"
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
                        .filter(\.isNotEmpty)
                let entries = sourceLines.compactMap { syllable -> String? in
                        lazy var errorMessage: String = "pinyin-syllable.txt : bad format : \(syllable)"
                        guard let code = syllable.charCode, code > 0 else { fatalError(errorMessage) }
                        guard let tenKeyCode = syllable.tenKeyCharCode, tenKeyCode > 0 else { fatalError(errorMessage) }
                        return "(\(code), \(tenKeyCode), '\(syllable)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insertValues: String = "INSERT INTO pinyinsyllabletable (code, tenkeycode, syllable) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insertValues, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
}
