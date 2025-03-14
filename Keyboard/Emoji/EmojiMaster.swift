import Foundation
import CoreIME
import CommonExtensions

struct EmojiMaster {

        private static let kEmojiFrequent: String = "EmojiFrequent"
        private static let deprecatedKey: String = "emoji_frequent"
        private static let frequentEmojiCount: Int = 30

        private static func processFrequent() -> [Emoji] {
                UserDefaults.standard.removeObject(forKey: deprecatedKey)
                guard let history = UserDefaults.standard.string(forKey: kEmojiFrequent) else { return defaultFrequent }
                let emojiTexts: [String] = history
                        .split(separator: ",")
                        .map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                        .filter(\.isNotEmpty)
                        .compactMap({ Emoji.generateSymbol(from: $0) })
                guard emojiTexts.count == frequentEmojiCount else { return defaultFrequent }
                let transformedEmojis: [Emoji] = emojiTexts.enumerated().map({ Emoji.generateFrequentEmoji(with: $0.element, uniqueNumber: $0.offset + 50000) })
                return transformedEmojis
        }
        static func updateFrequent(latest emoji: Emoji) {
                guard let previous = emojis[Emoji.Category.frequent] else { return }
                let combined = ([emoji] + previous).map(\.text).uniqued()
                guard combined.count >= frequentEmojiCount else { return }
                let updated = (combined.count == frequentEmojiCount) ? combined : combined.dropLast(combined.count - frequentEmojiCount)
                let value: String = updated.compactMap(\.first).map(\.formattedCodePointText).joined(separator: ",")
                UserDefaults.standard.set(value, forKey: kEmojiFrequent)
                let transformed: [Emoji] = updated.enumerated().map({ Emoji.generateFrequentEmoji(with: $0.element, uniqueNumber: $0.offset + 50000) })
                emojis[Emoji.Category.frequent] = transformed
        }
        static func clearFrequent() {
                UserDefaults.standard.removeObject(forKey: kEmojiFrequent)
                emojis[Emoji.Category.frequent] = defaultFrequent
        }

        private static let defaultFrequent: [Emoji] = Engine.fetchDefaultFrequentEmojis()
        private static let fetchedEmojis: [Emoji] = {
                if #available(iOSApplicationExtension 18.4, *) {
                        // Unicode/Emoji version 16.0
                        // return matched.filter({ $0.unicodeVersion <= 160000 }).uniqued()
                        return Engine.fetchEmojiSequence()
                } else if #available(iOSApplicationExtension 17.4, *) {
                        // Unicode/Emoji version 15.1
                        return Engine.fetchEmojiSequence().filter({ $0.unicodeVersion <= 151000 })
                } else if #available(iOSApplicationExtension 16.4, *) {
                        // Unicode/Emoji version 15.0
                        return Engine.fetchEmojiSequence().filter({ $0.unicodeVersion <= 150000 })
                } else if #available(iOSApplicationExtension 15.4, *) {
                        // Unicode/Emoji version 14.0
                        return Engine.fetchEmojiSequence().filter({ $0.unicodeVersion <= 140000 })
                } else {
                        return Engine.fetchEmojiSequence().filter({ $0.unicodeVersion < 140000 })
                }
        }()

        nonisolated(unsafe) private(set) static var emojis: [Emoji.Category: [Emoji]] = {
                var dict: [Emoji.Category: [Emoji]] = [:]
                for category in Emoji.Category.allCases {
                        dict[category] = fetchedEmojis.filter({ $0.category == category }).uniqued()
                }
                dict[Emoji.Category.frequent] = processFrequent()
                return dict
        }()
}

private extension Character {
        /// Example: é = "65.301"
        var formattedCodePointText: String {
                return self.unicodeScalars
                        .map({ String($0.value, radix: 16, uppercase: true) })
                        .joined(separator: ".")
        }
}
