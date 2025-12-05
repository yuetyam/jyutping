import Foundation
import SQLite3
import CommonExtensions

struct DatabasePreparer {

        nonisolated(unsafe) private static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                guard sqlite3_open_v2(":memory:", &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                return db
        }()

        static func prepare() async {
                await withTaskGroup(of: Void.self) { group in
                        group.addTask { await createCoreLexiconTable() }
                        group.addTask { await createStructureTable() }
                        group.addTask { await createPinyinTable() }
                        group.addTask { await createCangjieTable() }
                        group.addTask { await createQuickTable() }
                        group.addTask { await createStrokeTable() }
                        group.addTask { await createSymbolTable() }
                        group.addTask { await createEmojiSkinMapTable() }
                        group.addTask { await createTextMarkTable() }
                        group.addTask { await createSyllableTable() }
                        group.addTask { await createPinyinSyllableTable() }
                        group.addTask {
                                await createCharacterVariantTable(fileName: "CharacterVariant.AncientBooksPublishing", tableName: "variant_abp")
                        }
                        group.addTask {
                                await createCharacterVariantTable(fileName: "CharacterVariant.HongKong", tableName: "variant_hk")
                        }
                        group.addTask {
                                await createCharacterVariantTable(fileName: "CharacterVariant.Inherited", tableName: "variant_old")
                        }
                        group.addTask {
                                await createCharacterVariantTable(fileName: "CharacterVariant.PRCGeneral", tableName: "variant_prc")
                        }
                        group.addTask {
                                await createCharacterVariantTable(fileName: "CharacterVariant.Simplified", tableName: "variant_sim")
                        }
                        group.addTask {
                                await createCharacterVariantTable(fileName: "CharacterVariant.Taiwan", tableName: "variant_tw")
                        }
                        await group.waitForAll()
                }
                createIndexes()
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

        private static func createIndexes() {
                let commands: [String] = [
                        "CREATE INDEX ix_core_lexicon_spell ON core_lexicon(spell);",
                        "CREATE INDEX ix_core_lexicon_anchors ON core_lexicon(anchors);",
                        "CREATE INDEX ix_core_lexicon_strict ON core_lexicon(spell, anchors);",
                        "CREATE INDEX ix_core_lexicon_nine_key_code ON core_lexicon(nine_key_code);",
                        "CREATE INDEX ix_core_lexicon_nine_key_anchors ON core_lexicon(nine_key_anchors);",
                        "CREATE INDEX ix_core_lexicon_word ON core_lexicon(word);",

                        "CREATE INDEX ix_structure_spell ON structure_table(spell);",
                        "CREATE INDEX ix_structure_nine_key_code ON structure_table(nine_key_code);",

                        "CREATE INDEX ix_pinyin_spell ON pinyin_lexicon(spell);",
                        "CREATE INDEX ix_pinyin_anchors ON pinyin_lexicon(anchors);",
                        "CREATE INDEX ix_pinyin_strict ON pinyin_lexicon(spell, anchors);",
                        "CREATE INDEX ix_pinyin_nine_key_code ON pinyin_lexicon(nine_key_code);",
                        "CREATE INDEX ix_pinyin_nine_key_anchors ON pinyin_lexicon(nine_key_anchors);",

                        "CREATE INDEX ix_cangjie_cangjie5 ON cangjie_table(cangjie5);",
                        "CREATE INDEX ix_cangjie_c5code ON cangjie_table(c5code);",
                        "CREATE INDEX ix_cangjie_cangjie3 ON cangjie_table(cangjie3);",
                        "CREATE INDEX ix_cangjie_c3code ON cangjie_table(c3code);",

                        "CREATE INDEX ix_quick_quick5 ON quick_table(quick5);",
                        "CREATE INDEX ix_quick_q5code ON quick_table(q5code);",
                        "CREATE INDEX ix_quick_quick3 ON quick_table(quick3);",
                        "CREATE INDEX ix_quick_c3code ON quick_table(q3code);",

                        "CREATE INDEX ix_stroke_stroke ON stroke_table(stroke);",
                        "CREATE INDEX ix_stroke_spell ON stroke_table(spell);",
                        "CREATE INDEX ix_stroke_code ON stroke_table(code);",

                        "CREATE INDEX ix_symbol_spell ON symbol_table(spell);",
                        "CREATE INDEX ix_symbol_nine_key_code ON symbol_table(nine_key_code);",
                        "CREATE INDEX ix_emoji_skin_map_source ON emoji_skin_map(source);",

                        "CREATE INDEX ix_mark_spell ON mark_table(spell);",
                        "CREATE INDEX ix_mark_code ON mark_table(code);",
                        "CREATE INDEX ix_mark_nine_key_code ON mark_table(nine_key_code);",

                        "CREATE INDEX ix_syllable_nine_key_alias_code ON syllable_table(nine_key_alias_code);",
                        "CREATE INDEX ix_pinyin_syllable_nine_key_code ON pinyin_syllable_table(nine_key_code);",


                        "CREATE INDEX ix_variant_abp_left ON variant_abp(left);",
                        "CREATE INDEX ix_variant_abp_right ON variant_abp(right);",

                        "CREATE INDEX ix_variant_hk_left ON variant_hk(left);",
                        "CREATE INDEX ix_variant_hk_right ON variant_hk(right);",

                        "CREATE INDEX ix_variant_old_left ON variant_old(left);",
                        "CREATE INDEX ix_variant_old_right ON variant_old(right);",

                        "CREATE INDEX ix_variant_prc_left ON variant_prc(left);",
                        "CREATE INDEX ix_variant_prc_right ON variant_prc(right);",

                        "CREATE INDEX ix_variant_sim_left ON variant_sim(left);",
                        "CREATE INDEX ix_variant_sim_right ON variant_sim(right);",

                        "CREATE INDEX ix_variant_tw_left ON variant_tw(left);",
                        "CREATE INDEX ix_variant_tw_right ON variant_tw(right);",
                ]
                for command in commands {
                        var statement: OpaquePointer? = nil
                        defer { sqlite3_finalize(statement) }
                        guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(statement) == SQLITE_DONE else { return }
                }
        }

        private static func createCoreLexiconTable() async {
                let createTable: String = "CREATE TABLE core_lexicon(word TEXT NOT NULL, romanization TEXT NOT NULL, anchors INTEGER NOT NULL, spell INTEGER NOT NULL, nine_key_anchors INTEGER NOT NULL, nine_key_code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceEntries: [LexiconEntry] = LexiconConverter.jyutping()
                func insert(values: String) {
                        let insert: String = "INSERT INTO core_lexicon (word, romanization, anchors, spell, nine_key_anchors, nine_key_code) VALUES \(values);"
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
                                return "('\(entry.word)', '\(entry.romanization)', \(entry.anchors), \(entry.spell), \(entry.nineKeyAnchors), \(entry.nineKeyCode))"
                        }
                        let values: String = entries.joined(separator: ", ")
                        insert(values: values)
                }
        }
        private static func createCharacterVariantTable(fileName: String, tableName: String) async {
                let createTable: String = "CREATE TABLE \(tableName)(left INTEGER NOT NULL, right INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let sourceUrl: URL = Bundle.module.url(forResource: fileName, withExtension: "txt") else { fatalError("Can not load file \(fileName).txt") }
                let values: String = CharacterVariant.process(sourceUrl).map({ "(\($0.left), \($0.right))" }).joined(separator: ", ")
                let insert: String = "INSERT INTO \(tableName) (left, right) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createStructureTable() async {
                let createTable: String = "CREATE TABLE structure_table(word TEXT NOT NULL, romanization TEXT NOT NULL, spell INTEGER NOT NULL, nine_key_code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceEntries: [LexiconEntry] = LexiconConverter.structure()
                let entries = sourceEntries.map { entry -> String in
                        return "('\(entry.word)', '\(entry.romanization)', \(entry.spell), \(entry.nineKeyCode))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO structure_table (word, romanization, spell, nine_key_code) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createPinyinTable() async {
                let createTable: String = "CREATE TABLE pinyin_lexicon(word TEXT NOT NULL, romanization TEXT NOT NULL, anchors INTEGER NOT NULL, spell INTEGER NOT NULL, nine_key_anchors INTEGER NOT NULL, nine_key_code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceEntries: [LexiconEntry] = LexiconConverter.pinyin()
                func insert(values: String) {
                        let insert: String = "INSERT INTO pinyin_lexicon (word, romanization, anchors, spell, nine_key_anchors, nine_key_code) VALUES \(values);"
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
                                return "('\(entry.word)', '\(entry.romanization)', \(entry.anchors), \(entry.spell), \(entry.nineKeyAnchors), \(entry.nineKeyCode))"
                        }
                        let values: String = entries.joined(separator: ", ")
                        insert(values: values)
                }
        }
        private static func createCangjieTable() async {
                let createTable: String = "CREATE TABLE cangjie_table(word TEXT NOT NULL, cangjie5 TEXT NOT NULL, c5complex INTEGER NOT NULL, c5code INTEGER NOT NULL, cangjie3 TEXT NOT NULL, c3complex INTEGER NOT NULL, c3code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceEntries = Cangjie.generate()
                let entries = sourceEntries.map { entry -> String in
                        return "('\(entry.word)', '\(entry.cangjie5)', \(entry.c5complex), \(entry.c5code), '\(entry.cangjie3)', \(entry.c3complex), \(entry.c3code))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO cangjie_table (word, cangjie5, c5complex, c5code, cangjie3, c3complex, c3code) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createQuickTable() async {
                let createTable: String = "CREATE TABLE quick_table(word TEXT NOT NULL, quick5 TEXT NOT NULL, q5complex INTEGER NOT NULL, q5code INTEGER NOT NULL, quick3 TEXT NOT NULL, q3complex INTEGER NOT NULL, q3code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceEntries = Quick.generate()
                func insert(values: String) {
                        let insert: String = "INSERT INTO quick_table (word, quick5, q5complex, q5code, quick3, q3complex, q3code) VALUES \(values);"
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
                let createTable: String = "CREATE TABLE stroke_table(word TEXT NOT NULL, stroke TEXT NOT NULL, complex INTEGER NOT NULL, spell INTEGER NOT NULL, code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceEntries = Stroke.generate()
                func insert(values: String) {
                        let insert: String = "INSERT INTO stroke_table (word, stroke, complex, spell, code) VALUES \(values);"
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
                                return "('\(entry.word)', '\(entry.stroke)', \(entry.complex), \(entry.spell), \(entry.code))"
                        }
                        let values: String = entries.joined(separator: ", ")
                        insert(values: values)
                }
        }
        private static func createSymbolTable() async {
                let createTable: String = "CREATE TABLE symbol_table(category INTEGER NOT NULL, unicode_version INTEGER NOT NULL, code_point TEXT NOT NULL, cantonese TEXT NOT NULL, romanization TEXT NOT NULL, spell INTEGER NOT NULL, nine_key_code INTEGER NOT NULL);"
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
                        let spellCode = syllableText.hashCode()
                        let nineKeyCode = syllableText.nineKeyCharCode ?? 0
                        return "(\(category), \(version), '\(codePoint)', '\(cantonese)', '\(romanization)', \(spellCode), \(nineKeyCode))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO symbol_table (category, unicode_version, code_point, cantonese, romanization, spell, nine_key_code) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createEmojiSkinMapTable() async {
                let createTable: String = "CREATE TABLE emoji_skin_map(source TEXT NOT NULL, target TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "skin-tone-map", withExtension: "txt") else { return }
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
                let insert: String = "INSERT INTO emoji_skin_map (source, target) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createTextMarkTable() async {
                let createTable: String = "CREATE TABLE mark_table(input TEXT NOT NULL, mark TEXT NOT NULL, spell INTEGER NOT NULL, code INTEGER NOT NULL, nine_key_code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sources: [TextMarkLexicon] = TextMarkLexicon.convert()
                let entries = sources.map { entry -> String in
                        return "('\(entry.input)', '\(entry.mark)', \(entry.spellCode), \(entry.charCode), \(entry.nineKeyCharCode))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO mark_table (input, mark, spell, code, nine_key_code) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createSyllableTable() async {
                let createTable: String = "CREATE TABLE syllable_table(alias_code INTEGER NOT NULL PRIMARY KEY, origin_code INTEGER NOT NULL, nine_key_alias_code INTEGER NOT NULL, nine_key_origin_code INTEGER NOT NULL, alias TEXT NOT NULL, origin TEXT NOT NULL);"
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
                        guard let nineKeyAliasCode = alias.nineKeyCharCode, nineKeyAliasCode > 0 else { fatalError(errorMessage) }
                        guard let nineKeyOriginCode = origin.nineKeyCharCode, nineKeyOriginCode > 0 else { fatalError(errorMessage) }
                        return "(\(aliasCode), \(originCode), \(nineKeyAliasCode), \(nineKeyOriginCode), '\(alias)', '\(origin)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insertValues: String = "INSERT INTO syllable_table (alias_code, origin_code, nine_key_alias_code, nine_key_origin_code, alias, origin) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insertValues, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createPinyinSyllableTable() async {
                let createTable: String = "CREATE TABLE pinyin_syllable_table(code INTEGER NOT NULL PRIMARY KEY, nine_key_code INTEGER NOT NULL, syllable TEXT NOT NULL);"
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
                        guard let nineKeyCode = syllable.nineKeyCharCode, nineKeyCode > 0 else { fatalError(errorMessage) }
                        return "(\(code), \(nineKeyCode), '\(syllable)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insertValues: String = "INSERT INTO pinyin_syllable_table (code, nine_key_code, syllable) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insertValues, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
}
