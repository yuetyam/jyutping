import Foundation
import SQLite3
import CoreIME
import CommonExtensions

struct InputMemory {

        /// SQLITE_TRANSIENT replacement
        private static let transientDestructorType = unsafeBitCast(-1, to: sqlite3_destructor_type.self)


        // MARK: - Memory Migration

        private static func migrateMemory() async {
                if isLegacyDataPresent {
                        performMigration()
                } else {
                        missionAccomplished()
                }
        }
        private static func performMigration() {
                let savedValue: Int = savedInputMemoryMigration
                guard savedValue != definedMigrationValue else {
                        missionAccomplished()
                        return
                }
                if savedValue == 0 {
                        migrate(lower: 20, upper: 10_0000)
                        UserDefaults.standard.set(20, forKey: kMigration2026)
                }
                var upper: Int = (savedValue == 0) ? 20 : savedValue
                while upper > 1 {
                        let lower: Int = (upper - 1)
                        migrate(lower: lower, upper: upper)
                        UserDefaults.standard.set(lower, forKey: kMigration2026)
                        upper = lower
                }
                if upper <= 1 {
                        migrate(lower: 0, upper: 1)
                        missionAccomplished()
                }
        }
        private static func migrate(lower: Int, upper: Int) {
                let fetchedEntries = fetchLegacyEntries(lower: lower, upper: upper)
                guard fetchedEntries.isNotEmpty else { return }
                let command: String = "INSERT OR IGNORE INTO core_memory (word, romanization, frequency, latest, shortcut, spell, nine_key_anchors, nine_key_code) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                sqlite3_exec(database, "BEGIN;", nil, nil, nil)
                fetchedEntries.forEach({ entry in
                        sqlite3_reset(statement)
                        sqlite3_bind_text(statement, 1, (entry.word as NSString).utf8String, -1, transientDestructorType)
                        sqlite3_bind_text(statement, 2, (entry.romanization as NSString).utf8String, -1, transientDestructorType)
                        sqlite3_bind_int64(statement, 3, entry.frequency)
                        sqlite3_bind_int64(statement, 4, entry.latest)
                        sqlite3_bind_int64(statement, 5, Int64(entry.shortcut))
                        sqlite3_bind_int64(statement, 6, Int64(entry.spell))
                        sqlite3_bind_int64(statement, 7, Int64(entry.nineKeyAnchors))
                        sqlite3_bind_int64(statement, 8, Int64(entry.nineKeyCode))
                        sqlite3_step(statement)
                })
                sqlite3_exec(database, "COMMIT;", nil, nil, nil)
        }

        // memory(identifier INTEGER PRIMARY KEY, word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER, anchors INTEGER, shortcut INTEGER, ping INTEGER, tenkeyanchors INTEGER, tenkeycode INTEGER)
        private static func fetchLegacyEntries(lower: Int, upper: Int) -> [MemoryLexicon] {
                let command: String = "SELECT word, romanization, frequency, latest FROM memory WHERE frequency > \(lower) AND frequency <= \(upper);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var entries: [MemoryLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanization = sqlite3_column_text(statement, 1) else { continue }
                        let frequency: Int64 = sqlite3_column_int64(statement, 2)
                        let latest: Int64 = sqlite3_column_int64(statement, 3)
                        let instance = MemoryLexicon(word: String(cString: word), romanization: String(cString: romanization), frequency: frequency, latest: latest)
                        entries.append(instance)
                }
                return entries
        }
        private static var isLegacyDataPresent: Bool {
                let command: String = "SELECT frequency FROM memory WHERE frequency > 0 LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return false }
                guard sqlite3_step(statement) == SQLITE_ROW else { return false }
                let frequency: Int64 = sqlite3_column_int64(statement, 0)
                return frequency > 0
        }

        private static let definedMigrationValue: Int = 2026
        private static let kMigration2026: String = "InputMemoryMigration2026"
        private static var savedInputMemoryMigration: Int {
                return UserDefaults.standard.integer(forKey: kMigration2026)
        }
        private static func missionAccomplished() {
                UserDefaults.standard.set(definedMigrationValue, forKey: kMigration2026)
                cleanupObsoleteObjects()
                Task { @MainActor in
                        isMigrating = false
                }
        }
        private static func cleanupObsoleteObjects() {
                let kDoubleSpaceShortcut: String = "double_space_shortcut"
                UserDefaults.standard.removeObject(forKey: kDoubleSpaceShortcut)
                let kOldMarker: String = "is_user_lexicon_ready_v0.7"
                UserDefaults.standard.removeObject(forKey: kOldMarker)
                let kPreviousMigration: String = "InputMemoryVersion"
                UserDefaults.standard.removeObject(forKey: kPreviousMigration)
                let oldestDatabase = URL.libraryDirectory.appending(path: "userdb.sqlite3", directoryHint: .notDirectory)
                try? FileManager.default.removeItem(at: oldestDatabase)
                let previousDatabase = URL.libraryDirectory.appending(path: "userlexicon.sqlite3", directoryHint: .notDirectory)
                try? FileManager.default.removeItem(at: previousDatabase)
        }


        // MARK: - Database preparation

        nonisolated(unsafe) private static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                let path: String = URL.libraryDirectory.appending(path: "memory.sqlite3", directoryHint: .notDirectory).path()
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK {
                        return db
                } else {
                        sqlite3_close_v2(db)
                        return nil
                }
        }()
        nonisolated(unsafe) private static var isMigrating: Bool = false
        @MainActor static func prepare() {
                ensureTable()
                ensureIndexes()
                let isMigrated: Bool = (savedInputMemoryMigration == definedMigrationValue)
                if isMigrated.negative && isMigrating.negative {
                        isMigrating = true
                        Task(priority: .high) {
                                await migrateMemory()
                        }
                }
        }
        private static func ensureTable() {
                let command: String = "CREATE TABLE IF NOT EXISTS core_memory (id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT NOT NULL, romanization TEXT NOT NULL, frequency INTEGER NOT NULL, latest INTEGER NOT NULL, shortcut INTEGER NOT NULL, spell INTEGER NOT NULL, nine_key_anchors INTEGER NOT NULL, nine_key_code INTEGER NOT NULL, UNIQUE (word, romanization));"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func ensureIndexes() {
                for command in indexCommands {
                        var statement: OpaquePointer? = nil
                        defer { sqlite3_finalize(statement) }
                        guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { continue }
                        guard sqlite3_step(statement) == SQLITE_DONE else { continue }
                }
        }
        private static let indexCommands: [String] = [
                "CREATE INDEX IF NOT EXISTS ix_core_memory_frequency ON core_memory (frequency);",
                "CREATE INDEX IF NOT EXISTS ix_core_memory_shortcut ON core_memory (shortcut, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix_core_memory_spell ON core_memory (spell, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix_core_memory_strict ON core_memory (spell, shortcut, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix_core_memory_nine_key_anchors ON core_memory (nine_key_anchors, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix_core_memory_nine_key_code ON core_memory (nine_key_code, frequency DESC);",
        ]


        // MARK: - Candidate Handling

        static func handle(_ lexicon: Lexicon) {
                guard isMigrating.negative else { return }
                guard lexicon.isCantonese else { return }
                if let found = find(word: lexicon.text, romanization: lexicon.romanization) {
                        update(id: found.id, frequency: found.frequency + 1)
                } else {
                        let newEntry = MemoryLexicon(word: lexicon.text, romanization: lexicon.romanization)
                        insert(entry: newEntry)
                }
        }
        private static func find(word: String, romanization: String) -> (id: Int64, frequency: Int64)? {
                let command: String = "SELECT id, frequency FROM core_memory WHERE word = ? AND romanization = ? LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                guard sqlite3_bind_text(statement, 1, (word as NSString).utf8String, -1, transientDestructorType) == SQLITE_OK else { return nil }
                guard sqlite3_bind_text(statement, 2, (romanization as NSString).utf8String, -1, transientDestructorType) == SQLITE_OK else { return nil }
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                let id: Int64 = sqlite3_column_int64(statement, 0)
                let frequency: Int64 = sqlite3_column_int64(statement, 1)
                return (id, frequency)
        }
        private static func update(id: Int64, frequency: Int64) {
                let latest: Int64 = Int64(Date.now.timeIntervalSince1970 * 1000)
                let command: String = "UPDATE core_memory SET frequency = ?, latest = ? WHERE id = ?;"
                var statement: OpaquePointer?
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                sqlite3_bind_int64(statement, 1, frequency)
                sqlite3_bind_int64(statement, 2, latest)
                sqlite3_bind_int64(statement, 3, id)
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func insert(entry: MemoryLexicon) {
                let command: String = "INSERT INTO core_memory (word, romanization, frequency, latest, shortcut, spell, nine_key_anchors, nine_key_code) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                sqlite3_bind_text(statement, 1, (entry.word as NSString).utf8String, -1, transientDestructorType)
                sqlite3_bind_text(statement, 2, (entry.romanization as NSString).utf8String, -1, transientDestructorType)
                sqlite3_bind_int64(statement, 3, entry.frequency)
                sqlite3_bind_int64(statement, 4, entry.latest)
                sqlite3_bind_int64(statement, 5, Int64(entry.shortcut))
                sqlite3_bind_int64(statement, 6, Int64(entry.spell))
                sqlite3_bind_int64(statement, 7, Int64(entry.nineKeyAnchors))
                sqlite3_bind_int64(statement, 8, Int64(entry.nineKeyCode))
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }

        /// Delete the given Lexicon from the InputMemory
        static func forget(_ lexicon: Lexicon) {
                guard isMigrating.negative else { return }
                guard lexicon.isCantonese else { return }
                let command: String = "DELETE FROM core_memory WHERE word = ? AND romanization = ?;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                sqlite3_bind_text(statement, 1, (lexicon.text as NSString).utf8String, -1, transientDestructorType)
                sqlite3_bind_text(statement, 2, (lexicon.romanization as NSString).utf8String, -1, transientDestructorType)
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }

        /// Clear Input Memory
        static func deleteAll() {
                guard isMigrating.negative else { return }
                let command: String = "DELETE FROM core_memory;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }


        // MARK: - Suggestions

        static func suggest<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T, segmentation: Segmentation, deepSearch: Bool = true) async -> [Lexicon] {
                guard isMigrating.negative else { return [] }
                switch (keys.contains(where: \.isApostrophe), keys.contains(where: \.isToneInputKey)) {
                case (false, false):
                        return search(keys, segmentation: segmentation, deepSearch: deepSearch)
                case (true, true):
                        let syllableKeys = keys.filter(\.isSyllableLetter)
                        let candidates = search(syllableKeys, segmentation: segmentation, deepSearch: deepSearch)
                        let inputText = keys.map(\.text).joined()
                        let text = inputText.toneConverted()
                        return candidates.compactMap({ item -> Lexicon? in
                                guard text.hasPrefix(item.romanization) else { return nil }
                                return item.replacedInput(with: inputText)
                        })
                case (false, true):
                        let syllableKeys = keys.filter(\.isSyllableLetter)
                        let candidates = search(syllableKeys, segmentation: segmentation, deepSearch: deepSearch)
                        let inputText = keys.map(\.text).joined()
                        let text = inputText.toneConverted()
                        let textTones = text.tones
                        let qualified = candidates.compactMap({ item -> Lexicon? in
                                let syllableText = item.romanization.filter(\.isSpace.negative)
                                guard syllableText != text else { return item.replacedInput(with: inputText) }
                                let tones = syllableText.tones
                                switch (textTones.count, tones.count) {
                                case (1, 1):
                                        guard text.count == (item.inputCount + 1) else { return nil }
                                        guard (text.last?.isCantoneseToneDigit ?? false) else { return nil }
                                        guard textTones == tones else { return nil }
                                        return item.replacedInput(with: inputText)
                                case (1, 2):
                                        let isToneLast: Bool = text.last?.isCantoneseToneDigit ?? false
                                        if isToneLast {
                                                guard tones.hasSuffix(textTones) else { return nil }
                                                let isCorrectPosition: Bool = text.dropFirst(item.inputCount).first?.isCantoneseToneDigit ?? false
                                                guard isCorrectPosition else { return nil }
                                                return item.replacedInput(with: inputText)
                                        } else {
                                                guard tones.hasPrefix(textTones) else { return nil }
                                                return item.replacedInput(with: inputText)
                                        }
                                case (2, 2):
                                        guard (text.last?.isCantoneseToneDigit ?? false) else { return nil }
                                        guard textTones == tones else { return nil }
                                        guard item.inputCount == (text.count - 2) else { return nil }
                                        return item.replacedInput(with: inputText)
                                default:
                                        guard inputText != syllableText else { return item.replacedInput(with: inputText) }
                                        return nil
                                }
                        })
                        return qualified
                case (true, false):
                        let syllableKeys = keys.filter(\.isSyllableLetter)
                        let candidates = search(syllableKeys, segmentation: segmentation, deepSearch: deepSearch)
                        let isHeadingSeparator: Bool = keys.first?.isApostrophe ?? false
                        let isTrailingSeparator: Bool = keys.last?.isApostrophe ?? false
                        guard isHeadingSeparator.negative else { return [] }
                        let inputSeparatorCount = keys.count(where: \.isApostrophe)
                        let inputLength = keys.count
                        let text = keys.map(\.text).joined()
                        let textParts = text.split(separator: Character.apostrophe)
                        let qualified = candidates.compactMap({ item -> Lexicon? in
                                let syllables = item.romanization.removedTones().split(separator: Character.space)
                                guard syllables != textParts else { return item.replacedInput(with: text) }
                                switch inputSeparatorCount {
                                case 1 where isTrailingSeparator:
                                        guard syllables.count == 1 else { return nil }
                                        guard item.inputCount == (inputLength - 1) else { return nil }
                                        return item.replacedInput(with: text)
                                case 1:
                                        guard syllables.count == 2 else { return nil }
                                        let isMatched: Bool = {
                                                guard inputLength != 3 else { return true }
                                                guard syllables.first != textParts.first else { return true }
                                                guard textParts.first?.count == 1 else { return false }
                                                guard textParts.first?.first == syllables.first?.first else { return false }
                                                guard let lastSyllable = syllables.last else { return false }
                                                return textParts.last?.hasPrefix(lastSyllable) ?? false
                                        }()
                                        guard isMatched else { return nil }
                                        return item.replacedInput(with: text)
                                case 2 where isTrailingSeparator:
                                        guard syllables.count == 2 else { return nil }
                                        guard item.inputCount == (inputLength - 2) else { return nil }
                                        let isMatched: Bool = {
                                                guard inputLength != 4 else { return true }
                                                guard syllables.first != textParts.first else { return true }
                                                guard textParts.first?.count == 1 else { return false }
                                                guard textParts.first?.first == syllables.first?.first else { return false }
                                                return textParts.last == syllables.last
                                        }()
                                        guard isMatched else { return nil }
                                        return item.replacedInput(with: text)
                                case 2 where inputLength == 5 && textParts.count == 3,
                                        3 where inputLength == 6 && textParts.count == 3:
                                        guard syllables.count == 3 else { return nil }
                                        return item.replacedInput(with: text)
                                default:
                                        return nil
                                }
                        })
                        return qualified
                }
        }
        private static func search<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T, segmentation: Segmentation, deepSearch: Bool) -> [Lexicon] {
                lazy var shortcutStatement = prepareShortcutStatement()
                lazy var spellStatement = prepareSpellStatement()
                lazy var strictStatement = prepareStrictStatement()
                defer {
                        sqlite3_finalize(shortcutStatement)
                        sqlite3_finalize(spellStatement)
                        sqlite3_finalize(strictStatement)
                }
                let inputLength = keys.count
                let text = keys.map(\.text).joined()
                let fullMatched = spellMatch(text: text, input: text, statement: spellStatement)
                let idealSchemes = segmentation.filter({ $0.length == inputLength })
                let idealQueried: [InternalLexicon] = idealSchemes.flatMap({ scheme -> [InternalLexicon] in
                        let spellCode: Int32 = scheme.originText.hashCode()
                        let shortcutCode: Int32 = scheme.originAnchorsText.hashCode()
                        return strictMatch(spell: spellCode, shortcut: shortcutCode, input: text, mark: scheme.mark, statement: strictStatement)
                })
                let queried = query(segmentation: segmentation, idealSchemes: idealSchemes, deepSearch: deepSearch, strictStatement: strictStatement)
                guard fullMatched.isEmpty && idealQueried.isEmpty else {
                        return (fullMatched + idealQueried).distinct().map({ Lexicon(text: $0.word, romanization: $0.romanization, input: text, mark: $0.mark, number: -1) }) + queried
                }
                let shortcuts = shortcutMatch(text: text, input: text, limit: 5, statement: shortcutStatement)
                guard shortcuts.isEmpty else {
                        return shortcuts.map({ Lexicon(text: $0.word, romanization: $0.romanization, input: text, mark: $0.mark, number: -1) }) + queried
                }
                guard deepSearch else { return queried }
                let shouldPartiallyMatch: Bool = idealSchemes.isEmpty || (keys.last == VirtualInputKey.letterM) || (keys.first == VirtualInputKey.letterM)
                guard shouldPartiallyMatch else { return queried }
                let prefixMatched: [InternalLexicon] = segmentation.flatMap({ scheme -> [InternalLexicon] in
                        guard scheme.isNotEmpty else { return [] }
                        let tail = keys.dropFirst(scheme.length)
                        guard tail.isNotEmpty else { return [] }
                        let schemeAnchors = scheme.aliasAnchors
                        let conjoinedText: String = (schemeAnchors + tail).map(\.text).joined()
                        let schemeSyllableText: String = scheme.syllableText
                        let mark: String = scheme.mark + String.space + tail.map(\.text).joined()
                        let tailAsAnchorText = tail.compactMap({ $0.isYLetterY ? VirtualInputKey.letterJ.text.first : $0.text.first })
                        let conjoinedMatched = shortcutMatch(text: conjoinedText, input: conjoinedText, statement: shortcutStatement)
                                .compactMap({ item -> InternalLexicon? in
                                        let toneFreeRomanization = item.romanization.removedTones()
                                        guard toneFreeRomanization.hasPrefix(schemeSyllableText) else { return nil }
                                        let suffixAnchorText = toneFreeRomanization.dropFirst(schemeSyllableText.count).split(separator: Character.space).compactMap(\.first)
                                        guard suffixAnchorText == tailAsAnchorText else { return nil }
                                        return InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: mark)
                                })
                        let transformedTailText = tail.enumerated().map({ $0.offset == 0 && $0.element.isYLetterY ? VirtualInputKey.letterJ.text : $0.element.text }).joined()
                        let syllableText: String = schemeSyllableText + String.space + transformedTailText
                        let anchorsText: String = schemeAnchors.map(\.text).joined() + (tail.first?.text ?? String.empty)
                        let anchorsMatched = shortcutMatch(text: anchorsText, input: anchorsText, statement: shortcutStatement)
                                .compactMap({ item -> InternalLexicon? in
                                        guard item.romanization.removedTones().hasPrefix(syllableText) else { return nil }
                                        return InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: mark)
                                })
                        return conjoinedMatched + anchorsMatched
                })
                let gainedMatched: [InternalLexicon] = (1..<inputLength).reversed()
                        .flatMap({ number -> [InternalLexicon] in
                                let leadingText = keys.prefix(number).map(\.text).joined()
                                return shortcutMatch(text: leadingText, input: leadingText, statement: shortcutStatement)
                        })
                        .compactMap({ item -> InternalLexicon? in
                                // TODO: Cache tails and syllables ?
                                let tail = keys.dropFirst(item.inputCount - 1)
                                guard tail.count <= 6 else { return nil }
                                lazy var converted: InternalLexicon = InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: text)
                                guard item.romanization.removedSpacesTones().hasPrefix(text).negative else { return converted }
                                guard let lastSyllable = item.romanization.split(separator: Character.space).last?.filter(\.isCantoneseToneDigit.negative) else { return nil }
                                if let tailSyllable = Segmenter.syllableText(of: tail) {
                                        return lastSyllable == tailSyllable ? converted : nil
                                } else {
                                        let tailText = tail.map(\.text).joined()
                                        return lastSyllable.hasPrefix(tailText) ? converted : nil
                                }
                        })
                let partialMatched = (prefixMatched + gainedMatched)
                        .sorted()
                        .distinct()
                        .prefix(5)
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: text, mark: $0.mark, number: -1) })
                return partialMatched + queried
        }
        private static func query(segmentation: Segmentation, idealSchemes: [Scheme], deepSearch: Bool, strictStatement: OpaquePointer?) -> [Lexicon] {
                guard segmentation.isNotEmpty else { return [] }
                guard deepSearch else {
                        return idealSchemes.flatMap({ perform(scheme: $0, strictStatement: strictStatement) })
                                .sorted()
                                .distinct()
                                .prefix(6)
                                .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -2) })
                }
                if idealSchemes.isEmpty {
                        return segmentation.flatMap({ perform(scheme: $0, strictStatement: strictStatement) })
                                .sorted()
                                .distinct()
                                .prefix(6)
                                .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -2) })
                } else {
                        return idealSchemes.flatMap({ scheme -> [InternalLexicon] in
                                guard scheme.count > 1 else { return [] }
                                return (1..<scheme.count).reversed().map({ scheme.prefix($0) }).flatMap({ perform(scheme: $0, strictStatement: strictStatement) })
                        })
                        .sorted()
                        .distinct()
                        .prefix(6)
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -2) })
                }
        }
        private static func perform<T: RandomAccessCollection<Syllable>>(scheme: T, strictStatement: OpaquePointer?) -> [InternalLexicon] {
                let spellCode = scheme.originText.hashCode()
                let shortcutCode = scheme.originAnchorsText.hashCode()
                return strictMatch(spell: spellCode, shortcut: shortcutCode, input: scheme.aliasText, mark: scheme.mark, limit: 5, statement: strictStatement)
        }

        private static func shortcutMatch<T: StringProtocol>(text: T, input: String, limit: Int64 = 100, statement: OpaquePointer?) -> [InternalLexicon] {
                let code = text.replacingOccurrences(of: "y", with: "j").hashCode()
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, limit)
                var items: [InternalLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let frequency = sqlite3_column_int64(statement, 2)
                        let latest = sqlite3_column_int64(statement, 3)
                        let romanization: String = String(cString: romanizationText)
                        let instance = InternalLexicon(word: String(cString: word), romanization: romanization, frequency: frequency, latest: latest, input: input, mark: input)
                        items.append(instance)
                }
                return items
        }
        private static func spellMatch<T: StringProtocol>(text: T, input: String, mark: String? = nil, limit: Int64 = 100, statement: OpaquePointer?) -> [InternalLexicon] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(text.hashCode()))
                sqlite3_bind_int64(statement, 2, limit)
                var items: [InternalLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let frequency = sqlite3_column_int64(statement, 2)
                        let latest = sqlite3_column_int64(statement, 3)
                        let romanization: String = String(cString: romanizationText)
                        let mark: String = mark ?? romanization.removedTones()
                        let instance = InternalLexicon(word: String(cString: word), romanization: romanization, frequency: frequency, latest: latest, input: input, mark: mark)
                        items.append(instance)
                }
                return items
        }
        private static func strictMatch(spell: Int32, shortcut: Int32, input: String, mark: String? = nil, limit: Int64 = 100, statement: OpaquePointer?) -> [InternalLexicon] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(spell))
                sqlite3_bind_int64(statement, 2, Int64(shortcut))
                sqlite3_bind_int64(statement, 3, limit)
                var items: [InternalLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let frequency = sqlite3_column_int64(statement, 2)
                        let latest = sqlite3_column_int64(statement, 3)
                        let romanization: String = String(cString: romanizationText)
                        let mark: String = mark ?? romanization.removedTones()
                        let instance = InternalLexicon(word: String(cString: word), romanization: romanization, frequency: frequency, latest: latest, input: input, mark: mark)
                        items.append(instance)
                }
                return items
        }

        private static let shortcutQuery: String = "SELECT word, romanization, frequency, latest FROM core_memory WHERE shortcut = ? ORDER BY frequency DESC LIMIT ?;"
        private static func prepareShortcutStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, shortcutQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static let spellQuery: String = "SELECT word, romanization, frequency, latest FROM core_memory WHERE spell = ? ORDER BY frequency DESC LIMIT ?;"
        private static func prepareSpellStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, spellQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static let strictQuery: String = "SELECT word, romanization, frequency, latest FROM core_memory WHERE spell = ? AND shortcut = ? ORDER BY frequency DESC LIMIT ?;"
        private static func prepareStrictStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, strictQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }


        // MARK: - NineKey suggestions

        private static let nineKeyAnchorsCommand: String = "SELECT word, romanization, frequency, latest FROM core_memory WHERE nine_key_anchors = ? ORDER BY frequency DESC LIMIT ?;"
        private static func prepareNineKeyAnchorsStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, nineKeyAnchorsCommand, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static let nineKeyCodeCommand: String = "SELECT word, romanization, frequency, latest FROM core_memory WHERE nine_key_code = ? ORDER BY frequency DESC LIMIT ?;"
        private static func prepareNineKeyCodeStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, nineKeyCodeCommand, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static func nineKeyAnchorsMatch(code: Int, limit: Int64 = 5, statement: OpaquePointer?) -> [InternalLexicon] {
                guard code > 0 else { return [] }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, limit)
                var items: [InternalLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let frequency = sqlite3_column_int64(statement, 2)
                        let latest = sqlite3_column_int64(statement, 3)
                        let romanization: String = String(cString: romanizationText)
                        let anchorText: String = String(romanization.split(separator: Character.space).compactMap(\.first))
                        let instance = InternalLexicon(word: String(cString: word), romanization: romanization, frequency: frequency, latest: latest, input: anchorText, mark: anchorText)
                        items.append(instance)
                }
                return items
        }
        private static func nineKeyCodeMatch(code: Int, limit: Int64 = 100, statement: OpaquePointer?) -> [InternalLexicon] {
                guard code > 0 else { return [] }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, limit)
                var items: [InternalLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let frequency = sqlite3_column_int64(statement, 2)
                        let latest = sqlite3_column_int64(statement, 3)
                        let romanization: String = String(cString: romanizationText)
                        let input: String = romanization.filter(\.isLowercaseBasicLatinLetter)
                        let mark: String = romanization.removedTones()
                        let instance = InternalLexicon(word: String(cString: word), romanization: romanization, frequency: frequency, latest: latest, input: input, mark: mark)
                        items.append(instance)
                }
                return items
        }
        static func nineKeySearch<T: RandomAccessCollection<Combo>>(combos: T) async -> [Lexicon] {
                guard isMigrating.negative else { return [] }
                guard combos.isNotEmpty else { return [] }
                let inputLength = combos.count
                lazy var anchorsStatement = prepareNineKeyAnchorsStatement()
                lazy var codeStatement = prepareNineKeyCodeStatement()
                defer {
                        sqlite3_finalize(anchorsStatement)
                        sqlite3_finalize(codeStatement)
                }
                guard inputLength > 1 else {
                        guard let code = combos.first?.rawValue else { return [] }
                        let codeMatched = nineKeyCodeMatch(code: code, limit: 100, statement: codeStatement)
                        let anchorsMatched = nineKeyAnchorsMatch(code: code, limit: 100, statement: anchorsStatement)
                        return (codeMatched + anchorsMatched)
                                .distinct()
                                .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -1) })
                }
                let fullCode: Int = combos.map(\.digit).decimalCombined()
                let fullCodeMatched = nineKeyCodeMatch(code: fullCode, limit: 100, statement: codeStatement)
                let fullAnchorsMatched = nineKeyAnchorsMatch(code: fullCode, limit: 5, statement: anchorsStatement)
                let ideal = (fullCodeMatched.prefix(10) + (fullCodeMatched + fullAnchorsMatched).sorted())
                        .distinct()
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -1) })
                let queried = (1..<inputLength)
                        .flatMap({ number -> [InternalLexicon] in
                                let code = combos.dropLast(number).map(\.digit).decimalCombined()
                                guard code > 0 else { return [] }
                                return nineKeyCodeMatch(code: code, limit: 4, statement: codeStatement)
                        })
                        .distinct()
                        .prefix(6)
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -2) })
                return ideal + queried
        }
}

private struct InternalLexicon: Hashable, Comparable {
        let word: String
        let romanization: String
        let frequency: Int64
        let latest: Int64
        let input: String
        let inputCount: Int
        let mark: String
        init(word: String, romanization: String, frequency: Int64, latest: Int64, input: String, mark: String) {
                self.word = word
                self.romanization = romanization
                self.frequency = frequency
                self.latest = latest
                self.input = input
                self.inputCount = input.count
                self.mark = mark
        }
        static func == (lhs: InternalLexicon, rhs: InternalLexicon) -> Bool {
                return (lhs.word == rhs.word) && (lhs.romanization == rhs.romanization)
        }
        func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(romanization)
        }
        static func < (lhs: InternalLexicon, rhs: InternalLexicon) -> Bool {
                guard lhs.inputCount == rhs.inputCount else { return lhs.inputCount > rhs.inputCount }
                guard lhs.frequency == rhs.frequency else { return lhs.frequency > rhs.frequency }
                return lhs.latest > rhs.latest
        }
}
