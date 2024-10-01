import Foundation
import CoreIME
import CommonExtensions

struct EmojiMaster {

        private static let key: String = "emoji_frequent"
        private(set) static var frequent: [String] = {
                guard let history = UserDefaults.standard.string(forKey: key) else { return defaultFrequent }
                guard history.isNotEmpty else { return defaultFrequent }
                return history.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespaces) }).filter(\.isNotEmpty)
        }()
        static func updateFrequent(latest emoji: String) {
                let combined: [String] = ([emoji] + frequent).uniqued()
                let updated: [String] = combined.count <= 30 ? combined : combined.dropLast(combined.count - 30)
                frequent = updated
                let frequentText: String = updated.joined(separator: ",")
                UserDefaults.standard.set(frequentText, forKey: key)
                emojis[Emoji.Category.frequent] = transformFrequent()
        }
        static func clearFrequent() {
                frequent = defaultFrequent
                let emptyText: String = String.empty
                UserDefaults.standard.set(emptyText, forKey: key)
                emojis[Emoji.Category.frequent] = transformFrequent()
        }

        private static func transformFrequent() -> [Emoji] {
                var list: [Emoji] = []
                for index in frequent.indices {
                        let uniqueNumber: Int = 50000 + index
                        let emoji = Emoji.generateFrequentEmoji(with: frequent[index], uniqueNumber: uniqueNumber)
                        list.append(emoji)
                }
                return list
        }

        private(set) static var emojis: [Emoji.Category: [Emoji]] = {
                var dict: [Emoji.Category: [Emoji]] = [:]
                let fetched: [Emoji] = Engine.fetchEmoji()
                _ = Emoji.Category.allCases.map { category in
                        let matched: [Emoji] = fetched.filter({ $0.category == category })
                        let filtered: [Emoji] = {
                                if #available(iOSApplicationExtension 17.4, *) {
                                        return matched.uniqued()
                                } else if #available(iOSApplicationExtension 16.4, *) {
                                        return matched.filter({ !(new_in_iOS_17_4.contains($0.text)) }).uniqued()
                                } else if #available(iOSApplicationExtension 15.4, *) {
                                        return matched.filter({ !(new_in_iOS_17_4.contains($0.text) || new_in_iOS_16_4.contains($0.text)) }).uniqued()
                                } else {
                                        return matched.filter({ !(new_in_iOS_17_4.contains($0.text) || new_in_iOS_16_4.contains($0.text) || new_in_iOS_15_4.contains($0.text)) }).uniqued()
                                }
                        }()
                        dict[category] = filtered
                }
                dict[Emoji.Category.frequent] = transformFrequent()
                return dict
        }()


        private static let defaultFrequent: [String] = ["👋", "👍", "👌", "✌️", "👏", "🤩", "😍", "😘", "🥰", "😋", "😎", "😇", "🤗", "😏", "🤔", "❤️", "💖", "💕", "💞", "🌹", "🌚", "👀", "🐶", "👻", "🤪", "🍻", "🔥", "✅", "💯", "🎉"]

        private static let new_in_iOS_17_4: Set<String> = ["🙂‍↔️", "🙂‍↕️", "🚶‍➡️", "🚶‍♀️‍➡️", "🚶‍♂️‍➡️", "🧎‍➡️", "🧎‍♀️‍➡️", "🧎‍♂️‍➡️", "🧑‍🦯‍➡️", "👨‍🦯‍➡️", "👩‍🦯‍➡️", "🧑‍🦼‍➡️", "👨‍🦼‍➡️", "👩‍🦼‍➡️", "🧑‍🦽‍➡️", "👨‍🦽‍➡️", "👩‍🦽‍➡️", "🏃‍➡️", "🏃‍♀️‍➡️", "🏃‍♂️‍➡️", "🧑‍🧑‍🧒", "🧑‍🧑‍🧒‍🧒", "🧑‍🧒", "🧑‍🧒‍🧒", "🐦‍🔥", "🍋‍🟩", "🍄‍🟫", "⛓️‍💥"]

        private static let new_in_iOS_16_4: Set<String> = ["🫨", "🩷", "🩵", "🩶", "🫷", "🫸", "🫎", "🫏", "🪽", "🐦‍⬛", "🪿", "🪼", "🪻", "🫚", "🫛", "🪭", "🪮", "🪇", "🪈", "🪯", "🛜"]

        private static let new_in_iOS_15_4: Set<String> = ["🥹", "🫣", "🫢", "🫡", "🫠", "🫥", "🫤", "🫶", "🤝", "🫰", "🫳", "🫴", "🫲", "🫱", "🫵", "🫦", "🫅", "🧌", "🫄", "🫃", "🪺", "🪹", "🪸", "🪷", "🫧", "🫙", "🫘", "🫗", "🛝", "🩼", "🛞", "🛟", "🪫", "🪪", "🪬", "🩻", "🪩", "🟰"]
}
