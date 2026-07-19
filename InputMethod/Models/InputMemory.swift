import Foundation
import SQLite3
import CoreIME
import CommonExtensions

struct InputMemory {

        /// SQLITE_TRANSIENT replacement
        private static let DEFINED_SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)


        // MARK: - Memory Migration

        private static func migrateMemory() async {
                let previousMigrationKey: String = "InputMemoryMigration2026"
                let previousDefinedMigrationValue: Int = 2026
                let fetchedValue = UserDefaults.standard.integer(forKey: previousMigrationKey)
                let didPreviousMigrationCompleted: Bool = (fetchedValue == previousDefinedMigrationValue)
                let tableName: String = didPreviousMigrationCompleted ? "core_memory" : "memory"
                if isLegacyDataPresent(table: tableName) {
                        performMigration(table: tableName)
                } else {
                        missionAccomplished()
                }
        }

        private static func performMigration(table: String) {
                let savedValue: Int = savedInputMemoryMigration
                guard savedValue != definedMigrationValue else {
                        missionAccomplished()
                        return
                }
                if savedValue == 0 {
                        migrate(table: table, lower: 20, upper: 10_0000)
                        UserDefaults.standard.set(20, forKey: kMigrationKey)
                }
                var upper: Int = (savedValue == 0) ? 20 : savedValue
                while upper > 1 {
                        let lower: Int = (upper - 1)
                        migrate(table: table, lower: lower, upper: upper)
                        UserDefaults.standard.set(lower, forKey: kMigrationKey)
                        upper = lower
                }
                if upper <= 1 {
                        migrate(table: table, lower: 0, upper: 1)
                        missionAccomplished()
                }
        }
        private static func migrate(table: String, lower: Int, upper: Int) {
                let fetchedEntries = fetchLegacyEntries(table: table, lower: lower, upper: upper)
                guard fetchedEntries.isNotEmpty else { return }
                let command: String = "INSERT OR IGNORE INTO table2608 (word, romanization, frequency, latest, char_count, complex, anchors, spell) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                sqlite3_exec(database, "BEGIN;", nil, nil, nil)
                fetchedEntries.forEach({ entry in
                        sqlite3_reset(statement)
                        sqlite3_bind_text(statement, 1, (entry.word as NSString).utf8String, -1, DEFINED_SQLITE_TRANSIENT)
                        sqlite3_bind_text(statement, 2, (entry.romanization as NSString).utf8String, -1, DEFINED_SQLITE_TRANSIENT)
                        sqlite3_bind_int64(statement, 3, entry.frequency)
                        sqlite3_bind_int64(statement, 4, entry.latest)
                        sqlite3_bind_int64(statement, 5, entry.charCount.toInt64())
                        sqlite3_bind_int64(statement, 6, entry.complex.toInt64())
                        sqlite3_bind_int64(statement, 7, entry.anchors.toInt64())
                        sqlite3_bind_int64(statement, 8, entry.spell.toInt64())
                        sqlite3_step(statement)
                })
                sqlite3_exec(database, "COMMIT;", nil, nil, nil)
        }

        private static func fetchLegacyEntries(table: String, lower: Int, upper: Int) -> [MemoryLexicon] {
                let command: String = "SELECT word, romanization, frequency, latest FROM \(table) WHERE frequency > \(lower) AND frequency <= \(upper) ORDER BY frequency DESC;"
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
        private static func isLegacyDataPresent(table: String) -> Bool {
                let command: String = "SELECT frequency FROM \(table) WHERE frequency > 0 ORDER BY rowid LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return false }
                guard sqlite3_step(statement) == SQLITE_ROW else { return false }
                let frequency: Int64 = sqlite3_column_int64(statement, 0)
                return frequency > 0
        }

        private static let definedMigrationValue: Int = 2608
        private static let kMigrationKey: String = "InputMemoryMigration2608"
        private static var savedInputMemoryMigration: Int {
                return UserDefaults.standard.integer(forKey: kMigrationKey)
        }
        private static func missionAccomplished() {
                UserDefaults.standard.set(definedMigrationValue, forKey: kMigrationKey)
                cleanupObsoleteObjects()
                Task { @MainActor in
                        isMigrating = false
                }
        }
        private static func cleanupObsoleteObjects() {
                let previousMigrationKeys: [String] = ["InputMemoryMigration2026", "InputMemoryVersion"]
                previousMigrationKeys.forEach(UserDefaults.standard.removeObject(forKey:))
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
                let command: String = "CREATE TABLE IF NOT EXISTS table2608 (id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT NOT NULL, romanization TEXT NOT NULL, frequency INTEGER NOT NULL, latest INTEGER NOT NULL, char_count INTEGER NOT NULL, complex INTEGER NOT NULL, anchors INTEGER NOT NULL, spell INTEGER NOT NULL, UNIQUE (word, romanization));"
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
                "CREATE INDEX IF NOT EXISTS ix_frequency ON table2608 (frequency);",
                "CREATE INDEX IF NOT EXISTS ix_anchors ON table2608 (anchors, char_count, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix_spell ON table2608 (spell, complex, frequency DESC);",
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
                let command: String = "SELECT id, frequency FROM table2608 WHERE word = ? AND romanization = ? LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                guard sqlite3_bind_text(statement, 1, (word as NSString).utf8String, -1, DEFINED_SQLITE_TRANSIENT) == SQLITE_OK else { return nil }
                guard sqlite3_bind_text(statement, 2, (romanization as NSString).utf8String, -1, DEFINED_SQLITE_TRANSIENT) == SQLITE_OK else { return nil }
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                let id: Int64 = sqlite3_column_int64(statement, 0)
                let frequency: Int64 = sqlite3_column_int64(statement, 1)
                return (id, frequency)
        }
        private static func update(id: Int64, frequency: Int64) {
                let latest: Int64 = Int64(Date.now.timeIntervalSince1970 * 1000)
                let command: String = "UPDATE table2608 SET frequency = ?, latest = ? WHERE id = ?;"
                var statement: OpaquePointer?
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                sqlite3_bind_int64(statement, 1, frequency)
                sqlite3_bind_int64(statement, 2, latest)
                sqlite3_bind_int64(statement, 3, id)
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func insert(entry: MemoryLexicon) {
                let command: String = "INSERT INTO table2608 (word, romanization, frequency, latest, char_count, complex, anchors, spell) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                sqlite3_bind_text(statement, 1, (entry.word as NSString).utf8String, -1, DEFINED_SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 2, (entry.romanization as NSString).utf8String, -1, DEFINED_SQLITE_TRANSIENT)
                sqlite3_bind_int64(statement, 3, entry.frequency)
                sqlite3_bind_int64(statement, 4, entry.latest)
                sqlite3_bind_int64(statement, 5, entry.charCount.toInt64())
                sqlite3_bind_int64(statement, 6, entry.complex.toInt64())
                sqlite3_bind_int64(statement, 7, entry.anchors.toInt64())
                sqlite3_bind_int64(statement, 8, entry.spell.toInt64())
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }

        /// Delete the given Lexicon from the InputMemory
        static func forget(_ lexicon: Lexicon) {
                guard isMigrating.negative else { return }
                guard lexicon.isCantonese else { return }
                let command: String = "DELETE FROM table2608 WHERE word = ? AND romanization = ?;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                sqlite3_bind_text(statement, 1, (lexicon.text as NSString).utf8String, -1, DEFINED_SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 2, (lexicon.romanization as NSString).utf8String, -1, DEFINED_SQLITE_TRANSIENT)
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }

        /// Clear Input Memory
        static func deleteAll() {
                guard isMigrating.negative else { return }
                let command: String = "DELETE FROM table2608;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }


        // MARK: - Suggestions

        static func suggest<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T, segmentation: Segmentation) async -> [Lexicon] {
                guard isMigrating.negative else { return [] }
                switch (keys.contains(where: \.isApostrophe), keys.contains(where: \.isToneInputKey)) {
                case (false, false):
                        return search(keys, segmentation: segmentation)
                case (true, true):
                        let syllableKeys = keys.filter(\.isSyllableLetter)
                        let candidates = search(syllableKeys, segmentation: segmentation)
                        let inputText = keys.map(\.text).joined()
                        let text = inputText.toneConverted()
                        return candidates.compactMap({ item -> Lexicon? in
                                guard text.hasPrefix(item.romanization) else { return nil }
                                return item.replacedInput(with: inputText)
                        })
                case (false, true):
                        let syllableKeys = keys.filter(\.isSyllableLetter)
                        let candidates = search(syllableKeys, segmentation: segmentation)
                        let inputText = keys.map(\.text).joined()
                        let text = inputText.toneConverted()
                        let textTones = text.toneDigitOnly()
                        let qualified: [Lexicon] = candidates.compactMap({ item -> Lexicon? in
                                let syllableText = item.romanization.filter(\.isSpace.negative)
                                guard syllableText != text else { return item.replacedInput(with: inputText) }
                                let tones = syllableText.toneDigitOnly()
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
                        let candidates = search(syllableKeys, segmentation: segmentation)
                        let isHeadingSeparator: Bool = keys.first?.isApostrophe ?? false
                        let isTrailingSeparator: Bool = keys.last?.isApostrophe ?? false
                        guard isHeadingSeparator.negative else { return [] }
                        let inputSeparatorCount = keys.count(where: \.isApostrophe)
                        let inputLength = keys.count
                        let text = keys.map(\.text).joined()
                        let textParts = text.split(separator: Character.apostrophe)
                        let qualified: [Lexicon] = candidates.compactMap({ item -> Lexicon? in
                                let syllables = item.romanization.strippedTones().split(separator: Character.space)
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
        private static func search<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T, segmentation: Segmentation) -> [Lexicon] {
                lazy var anchorsStatement = prepareAnchorsStatement()
                lazy var spellStatement = prepareSpellStatement()
                defer {
                        sqlite3_finalize(anchorsStatement)
                        sqlite3_finalize(spellStatement)
                }
                let inputLength = keys.count
                let text = keys.map(\.text).joined()
                let fullMatched = spellMatch(keys: keys, input: text, statement: spellStatement)
                let idealSchemes = segmentation.filter({ $0.length == inputLength })
                let idealQueried: [InternalLexicon] = idealSchemes.flatMap({ scheme -> [InternalLexicon] in
                        return spellMatch(keys: scheme.originKeys, input: text, mark: scheme.mark, statement: spellStatement)
                })
                let queried = query(segmentation: segmentation, idealSchemes: idealSchemes, statement: spellStatement)
                guard fullMatched.isEmpty && idealQueried.isEmpty else {
                        return (fullMatched + idealQueried).regularSorted().map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -1) }) + queried
                }
                let shortcutLimit: Int64 = (segmentation.first?.isEmpty ?? true) ? 100 : 5
                let shortcuts = anchorsMatch(keys: keys, input: text, limit: shortcutLimit, statement: anchorsStatement)
                guard shortcuts.isEmpty else {
                        return shortcuts.regularSorted(isOrdered: true).map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -1) }) + queried
                }
                guard (inputLength > 2 && inputLength < 25) else { return queried }
                let shouldPartiallyMatch: Bool = idealSchemes.isEmpty || (keys.last == VirtualInputKey.letterM) || (keys.first == VirtualInputKey.letterM)
                guard shouldPartiallyMatch else { return queried }
                let prefixMatched: [InternalLexicon] = segmentation.flatMap({ scheme -> [InternalLexicon] in
                        guard scheme.isNotEmpty else { return [] }
                        let tail = keys.dropFirst(scheme.length)
                        guard tail.isNotEmpty else { return [] }
                        let schemeAnchors = scheme.aliasAnchors
                        let conjoined = schemeAnchors + tail
                        let schemeSyllableText: String = scheme.syllableText
                        let mark: String = scheme.mark + String.space + tail.map(\.text).joined()
                        let tailAsAnchorText = tail.compactMap({ $0.isYLetterY ? VirtualInputKey.letterJ.text.first : $0.text.first })
                        let conjoinedMatched = anchorsMatch(keys: conjoined, statement: anchorsStatement)
                                .compactMap({ item -> InternalLexicon? in
                                        let toneFreeRomanization = item.romanization.strippedTones()
                                        guard toneFreeRomanization.hasPrefix(schemeSyllableText) else { return nil }
                                        let suffixAnchorText = toneFreeRomanization.dropFirst(schemeSyllableText.count).split(separator: Character.space).compactMap(\.first)
                                        guard suffixAnchorText == tailAsAnchorText else { return nil }
                                        return InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: mark)
                                })
                        let transformedTailText = tail.enumerated().map({ $0.offset == 0 && $0.element.isYLetterY ? VirtualInputKey.letterJ.text : $0.element.text }).joined()
                        let syllableText: String = schemeSyllableText + String.space + transformedTailText
                        let anchors = schemeAnchors + [tail.first!]
                        let anchorsMatched = anchorsMatch(keys: anchors, statement: anchorsStatement)
                                .compactMap({ item -> InternalLexicon? in
                                        guard item.romanization.strippedTones().hasPrefix(syllableText) else { return nil }
                                        return InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: mark)
                                })
                        return conjoinedMatched + anchorsMatched
                })
                let gainedMatched: [InternalLexicon] = (1..<inputLength).reversed()
                        .flatMap({ number -> [InternalLexicon] in
                                return anchorsMatch(keys: keys.prefix(number), statement: anchorsStatement)
                        })
                        .compactMap({ item -> InternalLexicon? in
                                // TODO: Cache tails and syllables ?
                                let tail = keys.dropFirst(item.inputCount - 1)
                                guard tail.count <= 6 else { return nil }
                                lazy var converted: InternalLexicon = InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: text)
                                guard item.romanization.latinLetterOnly().hasPrefix(text).negative else { return converted }
                                guard let lastSyllable = item.romanization.split(separator: Character.space).last?.filter(\.isCantoneseToneDigit.negative) else { return nil }
                                if let tailSyllable = Segmenter.syllableText(of: tail) {
                                        return lastSyllable == tailSyllable ? converted : nil
                                } else {
                                        let tailText = tail.map(\.text).joined()
                                        return lastSyllable.hasPrefix(tailText) ? converted : nil
                                }
                        })
                let partialMatched = (prefixMatched + gainedMatched)
                        .peculiarSorted()
                        .prefix(5)
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: text, mark: $0.mark, number: -1) })
                return partialMatched + queried
        }
        private static func query(segmentation: Segmentation, idealSchemes: [Scheme], statement: OpaquePointer?) -> [Lexicon] {
                guard segmentation.isNotEmpty else { return [] }
                if idealSchemes.isEmpty {
                        return segmentation.flatMap({ perform(scheme: $0, statement: statement) })
                                .peculiarSorted()
                                .prefix(6)
                                .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -2) })
                } else {
                        return idealSchemes.flatMap({ scheme -> [InternalLexicon] in
                                guard scheme.count > 1 else { return [] }
                                return (1..<scheme.count).reversed().map({ scheme.prefix($0) }).flatMap({ perform(scheme: $0, statement: statement) })
                        })
                        .peculiarSorted()
                        .prefix(6)
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -2) })
                }
        }
        private static func perform<T: RandomAccessCollection<Syllable>>(scheme: T, statement: OpaquePointer?) -> [InternalLexicon] {
                return spellMatch(keys: scheme.originKeys, input: scheme.aliasText, mark: scheme.mark, limit: 5, statement: statement)
        }

        private static func anchorsMatch<T: RandomAccessCollection<VirtualInputKey>>(keys: T, input: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [InternalLexicon] {
                sqlite3_reset(statement)
                let anchorsCode: Int64 = keys.anchorNormalized.conjoinedCode.toInt64()
                let charCount: Int64 = keys.count.toInt64()
                let limit: Int64 = limit ?? 100
                sqlite3_bind_int64(statement, 1, anchorsCode)
                sqlite3_bind_int64(statement, 2, charCount)
                sqlite3_bind_int64(statement, 3, limit)
                let input: String = input ?? keys.map(\.text).joined()
                var items: [InternalLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let frequency = sqlite3_column_int64(statement, 2)
                        let latest = sqlite3_column_int64(statement, 3)
                        let instance = InternalLexicon(word: String(cString: word), romanization: String(cString: romanizationText), frequency: frequency, latest: latest, input: input, mark: input)
                        items.append(instance)
                }
                return items
        }
        private static func spellMatch<T: RandomAccessCollection<VirtualInputKey>>(keys: T, input: String? = nil, mark: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [InternalLexicon] {
                sqlite3_reset(statement)
                let spell: Int64 = keys.conjoinedCode.toInt64()
                let complex: Int64 = keys.count.toInt64()
                let limit: Int64 = limit ?? 100
                sqlite3_bind_int64(statement, 1, spell)
                sqlite3_bind_int64(statement, 2, complex)
                sqlite3_bind_int64(statement, 3, limit)
                let input: String = input ?? keys.map(\.text).joined()
                var items: [InternalLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let frequency = sqlite3_column_int64(statement, 2)
                        let latest = sqlite3_column_int64(statement, 3)
                        let romanization: String = String(cString: romanizationText)
                        let mark: String = mark ?? romanization.strippedTones()
                        let instance = InternalLexicon(word: String(cString: word), romanization: romanization, frequency: frequency, latest: latest, input: input, mark: mark)
                        items.append(instance)
                }
                return items
        }

        private static let anchorsQuery: String = "SELECT word, romanization, frequency, latest FROM table2608 WHERE anchors = ? AND char_count = ? ORDER BY frequency DESC LIMIT ?;"
        private static func prepareAnchorsStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, anchorsQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static let spellQuery: String = "SELECT word, romanization, frequency, latest FROM table2608 WHERE spell = ? AND complex = ? ORDER BY frequency DESC LIMIT ?;"
        private static func prepareSpellStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, spellQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
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

private extension Array where Element == InternalLexicon {
        func regularSorted(isOrdered: Bool = false) -> [InternalLexicon] {
                let frequencyPreferred = isOrdered ? self : sorted(by: { $0.frequency > $1.frequency })
                let datePreferred = sorted(by: { $0.latest > $1.latest })
                return (frequencyPreferred.prefix(3) + datePreferred.prefix(5) + frequencyPreferred).distinct()
        }
        func peculiarSorted() -> [InternalLexicon] {
                return map(\.inputCount).distinct().sorted(by: >).flatMap({ inputCount -> [InternalLexicon] in
                        return filter({ $0.inputCount == inputCount }).regularSorted()
                })
        }
}
