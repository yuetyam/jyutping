import Foundation
import CoreIME
import CommonExtensions
import SQLiteWrapper

struct InputMemory {

        // MARK: - Database preparation

        static let databaseURL: URL = URL.libraryDirectory.appending(path: "memory.sqlite3", directoryHint: .notDirectory)
        private static let store = InputMemoryPreparation(databaseURL: databaseURL)
        private static var database: SQLiteDatabase? { store.database }

        @MainActor static func prepare() {
                store.prepareForTyping()
        }

        static func waitUntilReady() async throws {
                try await store.waitUntilReady()
        }


        // MARK: - Candidate Handling

        static func handle(_ lexicon: Lexicon) {
                guard store.isReady else { return }
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
                let command: String = "INSERT INTO memory2608 (word, romanization, frequency, latest, char_count, letter_count, complexity, anchors, spell) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);"
                try? database?.run(command, entry.word, entry.romanization, entry.frequency, entry.latest, entry.charCount, entry.letterCount, entry.complexity, entry.anchors, entry.spell)
        }

        /// Delete the given Lexicon from the InputMemory
        static func forget(_ lexicon: Lexicon) {
                guard store.isReady else { return }
                guard lexicon.isCantonese else { return }
                let command: String = "DELETE FROM memory2608 WHERE word = ? AND romanization = ?;"
                try? database?.run(command, lexicon.text, lexicon.romanization)
        }

        /// Clear Input Memory
        static func deleteAll() {
                guard store.isReady else { return }
                let command: String = "DELETE FROM memory2608;"
                try? database?.run(command)
        }


        // MARK: - Suggestions

        /// Preferred maximum number of syllables in one lexicon entry
        private static let MAX_CHAR_COUNT: Int = 9

        static func suggest<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T, segmentation: Segmentation) async -> [Lexicon] {
                guard store.isReady else { return [] }
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
                lazy var anchorsStatement = try? database?.prepare(anchorsQuery)
                lazy var spellStatement = try? database?.prepare(spellQuery)
                let inputLength = keys.count
                let idealSchemes = segmentation.filter({ $0.length == inputLength })
                let queried = query(inputLength: inputLength, segmentation: segmentation, idealSchemes: idealSchemes, statement: spellStatement)
                let idealQueried = queried.filter({ $0.inputCount >= inputLength })
                        .regularSorted()
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -1) })
                let notIdealQueried = queried.filter({ $0.inputCount < inputLength })
                        .peculiarSorted()
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -2) })
                let anchorsMatched = anchorsMatch(keys: keys, limit: (queried.isEmpty ? 20 : 5), statement: anchorsStatement)
                        .regularSorted(isOrdered: true)
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, number: -1) })
                guard idealQueried.isEmpty && anchorsMatched.isEmpty else {
                        return idealQueried + anchorsMatched + notIdealQueried
                }
                guard (inputLength > 2 && inputLength < 25) else { return notIdealQueried }
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
        private static func query(inputLength: Int, segmentation: Segmentation, idealSchemes: [Scheme], statement: SQLiteStatement?) -> [InternalLexicon] {
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
