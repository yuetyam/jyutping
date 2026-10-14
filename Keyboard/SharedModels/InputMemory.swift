import Foundation
import CoreIME
import CommonExtensions
import SQLiteWrapper

struct InputMemory {

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
                let command: String = "INSERT OR IGNORE INTO memory2608 (word, romanization, frequency, latest, char_count, letter_count, complexity, anchors, spell, anchors_9key, spell_9key) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
                guard let database, let statement = try? database.prepare(command) else { return }
                try? database.transaction {
                        fetchedEntries.forEach({ entry in
                                try? statement.run(entry.word, entry.romanization, entry.frequency, entry.latest, entry.charCount, entry.letterCount, entry.complexity, entry.anchors, entry.spell, entry.nineKeyAnchors, entry.nineKeySpell)
                        })
                }
        }

        private static func fetchLegacyEntries(table: String, lower: Int, upper: Int) -> [MemoryLexicon] {
                let command: String = "SELECT word, romanization, frequency, latest FROM \(table) WHERE frequency > \(lower) AND frequency <= \(upper) ORDER BY frequency DESC;"
                let entries = try? database?.query(command, transform: { row -> MemoryLexicon? in
                        guard let word = row.text(at: 0), let romanization = row.text(at: 1) else { return nil }
                        return MemoryLexicon(word: word, romanization: romanization, frequency: row.int64(at: 2), latest: row.int64(at: 3))
                })
                return entries ?? []
        }
        private static func isLegacyDataPresent(table: String) -> Bool {
                let command: String = "SELECT frequency FROM \(table) WHERE frequency > 0 ORDER BY rowid LIMIT 1;"
                guard let frequency = try? database?.first(command, transform: { $0.int64(at: 0) }) else { return false }
                return frequency > 0
        }

        private static let definedMigrationValue: Int = 2608
        private static let kMigrationKey: String = "Migration2608"
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
                let kDoubleSpaceShortcut: String = "double_space_shortcut"
                UserDefaults.standard.removeObject(forKey: kDoubleSpaceShortcut)
                let kOldMarker: String = "is_user_lexicon_ready_v0.7"
                UserDefaults.standard.removeObject(forKey: kOldMarker)
                let previousMigrationKeys: [String] = ["InputMemoryMigration2026", "InputMemoryVersion"]
                previousMigrationKeys.forEach(UserDefaults.standard.removeObject(forKey:))
                let oldestDatabase = URL.libraryDirectory.appending(path: "userdb.sqlite3", directoryHint: .notDirectory)
                try? FileManager.default.removeItem(at: oldestDatabase)
                let previousDatabase = URL.libraryDirectory.appending(path: "userlexicon.sqlite3", directoryHint: .notDirectory)
                try? FileManager.default.removeItem(at: previousDatabase)
        }


        // MARK: - Database preparation

        static let databaseURL: URL = URL.libraryDirectory.appending(path: "memory.sqlite3", directoryHint: .notDirectory)
        nonisolated(unsafe) private static let database: SQLiteDatabase? = {
                return try? SQLiteDatabase(url: databaseURL, flags: [.readWrite, .create, .fullMutex])
        }()
        nonisolated(unsafe) private static var isMigrating: Bool = false

        /// The store exists and its migration has completed, so it can be exported or imported into.
        static var isReady: Bool {
                return database != nil && isMigrating.negative && savedInputMemoryMigration == definedMigrationValue
        }
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
                let command: String = "CREATE TABLE IF NOT EXISTS memory2608 (id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT NOT NULL, romanization TEXT NOT NULL, frequency INTEGER NOT NULL, latest INTEGER NOT NULL, char_count INTEGER NOT NULL, letter_count INTEGER NOT NULL, complexity INTEGER NOT NULL, anchors INTEGER NOT NULL, spell INTEGER NOT NULL, anchors_9key INTEGER NOT NULL, spell_9key INTEGER NOT NULL, UNIQUE (word, romanization));"
                try? database?.run(command)
        }
        private static func ensureIndexes() {
                for command in indexCommands {
                        try? database?.run(command)
                }
        }
        private static let indexCommands: [String] = [
                "CREATE INDEX IF NOT EXISTS ix2608_frequency ON memory2608 (frequency);",
                "CREATE INDEX IF NOT EXISTS ix2608_anchors ON memory2608 (anchors, char_count, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix2608_spell ON memory2608 (spell, letter_count, complexity, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix2608_anchors_9key ON memory2608 (anchors_9key, char_count, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix2608_spell_9key ON memory2608 (spell_9key, letter_count, complexity, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix2608_word ON memory2608 (word, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix2608_lexicon ON memory2608 (word, romanization);",
        ]

        private static func dropTable(tableName: String) {
                let command: String = "DROP TABLE IF EXISTS \(tableName);"
                guard let database, (try? database.execute(command)) != nil else { return }
                try? database.execute("VACUUM;")
        }


        // MARK: - Candidate Handling

        static func handle(_ lexicon: Lexicon) {
                guard isMigrating.negative else { return }
                guard lexicon.isCantonese else { return }
                if let found = find(word: lexicon.text, romanization: lexicon.romanization) {
                        let updatedFrequency: Int64 = (found.frequency < Int64.max) ? (found.frequency + 1) : Int64.max
                        update(id: found.id, frequency: updatedFrequency)
                } else {
                        let newEntry = MemoryLexicon(word: lexicon.text, romanization: lexicon.romanization)
                        insert(entry: newEntry)
                }
        }
        private static func find(word: String, romanization: String) -> (id: Int64, frequency: Int64)? {
                let command: String = "SELECT id, frequency FROM memory2608 WHERE word = ? AND romanization = ? LIMIT 1;"
                return try? database?.first(command, word, romanization, transform: { ($0.int64(at: 0), $0.int64(at: 1)) })
        }
        private static func update(id: Int64, frequency: Int64) {
                let latest: Int64 = Int64(Date.now.timeIntervalSince1970 * 1000)
                let command: String = "UPDATE memory2608 SET frequency = ?, latest = ? WHERE id = ?;"
                try? database?.run(command, frequency, latest, id)
        }
        private static func insert(entry: MemoryLexicon) {
                let command: String = "INSERT INTO memory2608 (word, romanization, frequency, latest, char_count, letter_count, complexity, anchors, spell, anchors_9key, spell_9key) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
                try? database?.run(command, entry.word, entry.romanization, entry.frequency, entry.latest, entry.charCount, entry.letterCount, entry.complexity, entry.anchors, entry.spell, entry.nineKeyAnchors, entry.nineKeySpell)
        }

        /// Delete the given Lexicon from the InputMemory
        static func forget(_ lexicon: Lexicon) {
                guard isMigrating.negative else { return }
                guard lexicon.isCantonese else { return }
                let command: String = "DELETE FROM memory2608 WHERE word = ? AND romanization = ?;"
                try? database?.run(command, lexicon.text, lexicon.romanization)
        }

        /// Clear Input Memory
        static func deleteAll() {
                guard isMigrating.negative else { return }
                let command: String = "DELETE FROM memory2608;"
                try? database?.run(command)
        }

        static func inspect(lexicon: Lexicon) -> (frequency: Int64, latest: Int64) {
                let command: String = "SELECT frequency, latest FROM memory2608 WHERE word = ? AND romanization = ? LIMIT 1;"
                let found = try? database?.first(command, lexicon.text, lexicon.romanization, transform: { row -> (frequency: Int64, latest: Int64)? in (row.int64(at: 0), row.int64(at: 1)) })
                return found ?? (0, 0)
        }


        // MARK: - Suggestions

        /// Preferred maximum number of syllables in one lexicon entry
        private static let MAX_CHAR_COUNT: Int = 9

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
                        let textTones = text.toneDigitOnly()
                        let qualified = candidates.compactMap({ item -> Lexicon? in
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
                        let candidates = search(syllableKeys, segmentation: segmentation, deepSearch: deepSearch)
                        let isHeadingSeparator: Bool = keys.first?.isApostrophe ?? false
                        let isTrailingSeparator: Bool = keys.last?.isApostrophe ?? false
                        guard isHeadingSeparator.negative else { return [] }
                        let inputSeparatorCount = keys.count(where: \.isApostrophe)
                        let inputLength = keys.count
                        let text = keys.map(\.text).joined()
                        let textParts = text.split(separator: Character.apostrophe)
                        let qualified = candidates.compactMap({ item -> Lexicon? in
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
        private static func search<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T, segmentation: Segmentation, deepSearch: Bool) -> [Lexicon] {
                lazy var anchorsStatement = try? database?.prepare(anchorsQuery)
                lazy var spellStatement = try? database?.prepare(spellQuery)
                let inputLength = keys.count
                let idealSchemes = segmentation.filter({ $0.length == inputLength })
                let queried = query(inputLength: inputLength, segmentation: segmentation, idealSchemes: idealSchemes, deepSearch: deepSearch, statement: spellStatement)
                let anchorsMatched = anchorsMatch(keys: keys, limit: (queried.isEmpty ? 20 : 5), statement: anchorsStatement)
                        .regularSorted(isOrdered: true)
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -1) })
                guard deepSearch else {
                        let fullMatched = queried.regularSorted().map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -1) })
                        return fullMatched + anchorsMatched
                }
                let idealQueried = queried.filter({ $0.inputCount >= inputLength })
                        .regularSorted()
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -1) })
                let notIdealQueried = queried.filter({ $0.inputCount < inputLength })
                        .peculiarSorted()
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -2) })
                guard idealQueried.isEmpty && anchorsMatched.isEmpty else {
                        return idealQueried + anchorsMatched + notIdealQueried
                }
                guard inputLength > 2 && inputLength < 25 else { return notIdealQueried }
                let shouldPartiallyMatch: Bool = idealSchemes.isEmpty || (keys.last == VirtualInputKey.letterM) || (keys.first == VirtualInputKey.letterM)
                guard shouldPartiallyMatch else { return notIdealQueried }
                let text = keys.map(\.text).joined()
                let prefixMatched: [InternalLexicon] = segmentation.flatMap({ scheme -> [InternalLexicon] in
                        guard Task.isCancelled.negative else { return [] }
                        let leadingCharCount = scheme.count
                        guard leadingCharCount > 0 && leadingCharCount <= MAX_CHAR_COUNT else { return [] }
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
                                guard Task.isCancelled.negative && (number <= MAX_CHAR_COUNT) else { return [] }
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
                return partialMatched + notIdealQueried
        }
        private static func query(inputLength: Int,segmentation: Segmentation, idealSchemes: [Scheme], deepSearch: Bool, statement: SQLiteStatement?) -> [InternalLexicon] {
                guard deepSearch else {
                        guard idealSchemes.isNotEmpty else { return [] }
                        return idealSchemes.flatMap({ perform(scheme: $0, limit: 10, statement: statement) })
                }
                if idealSchemes.isEmpty {
                        return segmentation.flatMap({ perform(scheme: $0, statement: statement) })
                } else {
                        return idealSchemes.flatMap({ scheme -> [InternalLexicon] in
                                return (1...scheme.count).reversed().flatMap({ perform(scheme: scheme.prefix($0), limit: ($0 == scheme.count) ? 20 : 5, statement: statement) })
                        })
                }
        }
        private static func perform<T: RandomAccessCollection<Syllable>>(scheme: T, limit: Int64 = 5, statement: SQLiteStatement?) -> [InternalLexicon] {
                guard Task.isCancelled.negative else { return [] }
                return spellMatch(keys: scheme.originKeys, complexity: scheme.complexity, input: scheme.aliasText, mark: scheme.mark, limit: limit, statement: statement)
        }

        private static func anchorsMatch<T: RandomAccessCollection<VirtualInputKey>>(keys: T, input: String? = nil, limit: Int64? = nil, statement: SQLiteStatement?) -> [InternalLexicon] {
                guard let statement else { return [] }
                let anchorsCode: Int64 = keys.anchorNormalized.conjoinedCode.toInt64()
                let charCount: Int64 = keys.count.toInt64()
                let limit: Int64 = limit ?? 100
                let input: String = input ?? keys.map(\.text).joined()
                let items = try? statement.query(anchorsCode, charCount, limit, transform: { row -> InternalLexicon? in
                        guard let word = row.text(at: 0), let romanization = row.text(at: 1) else { return nil }
                        return InternalLexicon(word: word, romanization: romanization, frequency: row.int64(at: 2), latest: row.int64(at: 3), input: input, mark: input)
                })
                return items ?? []
        }
        private static func spellMatch<T: RandomAccessCollection<VirtualInputKey>>(keys: T, complexity: Int, input: String? = nil, mark: String? = nil, limit: Int64? = nil, statement: SQLiteStatement?) -> [InternalLexicon] {
                guard let statement else { return [] }
                let spell: Int64 = keys.conjoinedCode.toInt64()
                let letterCount: Int64 = keys.count.toInt64()
                let complexity: Int64 = complexity.toInt64()
                let limit: Int64 = limit ?? 100
                let input: String = input ?? keys.map(\.text).joined()
                let items = try? statement.query(spell, letterCount, complexity, limit, transform: { row -> InternalLexicon? in
                        guard let word = row.text(at: 0), let romanization = row.text(at: 1) else { return nil }
                        let mark: String = mark ?? romanization.strippedTones()
                        return InternalLexicon(word: word, romanization: romanization, frequency: row.int64(at: 2), latest: row.int64(at: 3), input: input, mark: mark)
                })
                return items ?? []
        }

        private static let anchorsQuery: String = "SELECT word, romanization, frequency, latest FROM memory2608 WHERE anchors = ? AND char_count = ? ORDER BY frequency DESC LIMIT ?;"
        private static let spellQuery: String = "SELECT word, romanization, frequency, latest FROM memory2608 WHERE spell = ? AND letter_count = ? AND complexity = ? ORDER BY frequency DESC LIMIT ?;"


        // MARK: - NineKey suggestions

        private static let nineKeyAnchorsCommand: String = "SELECT word, romanization, frequency, latest FROM memory2608 WHERE anchors_9key = ? AND char_count = ? ORDER BY frequency DESC LIMIT ?;"
        private static let nineKeySpellCommand: String = "SELECT word, romanization, frequency, latest FROM memory2608 WHERE spell_9key = ? AND letter_count = ? AND complexity = ? ORDER BY frequency DESC LIMIT ?;"

        private static func nineKeyAnchorsMatch<T: RandomAccessCollection<Combo>>(combos: T, limit: Int64 = 50, statement: SQLiteStatement?) -> [InternalLexicon] {
                guard let statement else { return [] }
                let items = try? statement.query(combos.decimalCombinedCode.toInt64(), combos.count.toInt64(), limit, transform: { row -> InternalLexicon? in
                        guard let word = row.text(at: 0), let romanization = row.text(at: 1) else { return nil }
                        let anchorText: String = String(romanization.split(separator: Character.space).compactMap(\.first))
                        return InternalLexicon(word: word, romanization: romanization, frequency: row.int64(at: 2), latest: row.int64(at: 3), input: anchorText, mark: anchorText)
                })
                return items ?? []
        }
        private static func nineKeySpellMatch<T: RandomAccessCollection<Combo>>(combos: T, complexity: Int, limit: Int64 = 50, statement: SQLiteStatement?) -> [InternalLexicon] {
                guard let statement else { return [] }
                let nineKeySpell: Int64 = combos.decimalCombinedCode.toInt64()
                let letterCount: Int64 = combos.count.toInt64()
                let items = try? statement.query(nineKeySpell, letterCount, complexity.toInt64(), limit, transform: { row -> InternalLexicon? in
                        guard let word = row.text(at: 0), let romanization = row.text(at: 1) else { return nil }
                        let input: String = romanization.filter(\.isLowercaseBasicLatinLetter)
                        let mark: String = romanization.strippedTones()
                        return InternalLexicon(word: word, romanization: romanization, frequency: row.int64(at: 2), latest: row.int64(at: 3), input: input, mark: mark)
                })
                return items ?? []
        }

        private static func nineKeyPerform<T: RandomAccessCollection<NineKeySyllable>>(scheme: T, limit: Int64 = 50, statement: SQLiteStatement?) -> [InternalLexicon] {
                guard Task.isCancelled.negative else { return [] }
                let containsIrregular: Bool = scheme.contains(where: \.isIrregular)
                if containsIrregular {
                        let serialStatement = try? database?.prepare(spellQuery)
                        return spellMatch(keys: scheme.serialOriginKeys, complexity: scheme.complexity, limit: limit, statement: serialStatement)
                } else {
                        return nineKeySpellMatch(combos: scheme.originCombos, complexity: scheme.complexity, limit: limit, statement: statement)
                }
        }
        private static func nineKeyQuery(inputLength: Int, segmentation: NineKeySegmentation, statement: SQLiteStatement?) -> [InternalLexicon] {
                let idealSchemes = segmentation.filter({ $0.length == inputLength })
                if idealSchemes.isEmpty {
                        return segmentation.flatMap({ nineKeyPerform(scheme: $0, limit: 10, statement: statement) })
                } else {
                        return idealSchemes.flatMap({ scheme -> [InternalLexicon] in
                                switch scheme.count {
                                case 0: return []
                                case 1: return nineKeyPerform(scheme: scheme, limit: 20, statement: statement)
                                default:
                                        return (1...scheme.count).reversed().flatMap({ nineKeyPerform(scheme: scheme.prefix($0), limit: ($0 == scheme.count) ? 30 : 10, statement: statement) })
                                }
                        })
                }
        }
        static func nineKeySearch<T: RandomAccessCollection<Combo>>(combos: T, segmentation: NineKeySegmentation) async -> [Lexicon] {
                guard isMigrating.negative else { return [] }
                guard combos.isNotEmpty else { return [] }
                lazy var anchorsStatement = try? database?.prepare(nineKeyAnchorsCommand)
                lazy var spellStatement = try? database?.prepare(nineKeySpellCommand)
                let inputLength = combos.count
                guard inputLength > 1 else {
                        return nineKeyAnchorsMatch(combos: combos, statement: anchorsStatement)
                                .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -1) })
                }
                let anchorsMatched = nineKeyAnchorsMatch(combos: combos, statement: anchorsStatement).regularSorted(isOrdered: true)
                let queried = nineKeyQuery(inputLength: inputLength, segmentation: segmentation, statement: spellStatement).regularSorted()
                let fullMatched = queried.filter({ $0.inputCount >= inputLength }).regularSorted()
                let ideal = (fullMatched.prefix(10) + (fullMatched + anchorsMatched.prefix(5)).regularSorted())
                        .distinct()
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -1) })
                let notIdeal = queried.filter({ $0.inputCount < inputLength })
                        .peculiarSorted()
                        .prefix(6)
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -2) })
                return ideal + notIdeal
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
