import UIKit
import EmojiData

struct Emoji {

        private(set) static var frequent: String = {
                let history: String = UserDefaults.standard.string(forKey: "emoji_frequent") ?? .empty
                if !(history.isEmpty) {
                        return history
                } else {
                        // FIXME: iOS 13, 14 compatibility
                        return "😂☺️💕👍🙈😴❤️😊😔✌️😎😄😍😘😏😉🎶😜😒😭😁😌👀😋👌😫😳🥰😑👏"
                }
        }()

        static func updateFrequentEmojis(latest emoji: String) {
                let combined: String = emoji + frequent
                let uniqued: [String] = combined.map({ String($0) }).uniqued()
                let updated: [String] = uniqued.count < 31 ? uniqued : uniqued.dropLast(uniqued.count - 30)
                frequent = updated.joined()
                UserDefaults.standard.set(frequent, forKey: "emoji_frequent")
        }
        static func clearFrequentEmojis() {
                let emptyText: String = .empty
                frequent = emptyText
                UserDefaults.standard.set(emptyText, forKey: "emoji_frequent")
        }

        static let sequences: [[String]] = {
                let emojis: [[String]] = EmojiData.fetchAll()
                if #available(iOSApplicationExtension 14.5, *) {
                        return emojis
                } else {
                        let font: UIFont = UIFont(name: "Apple Color Emoji", size: 17) ?? .systemFont(ofSize: 17)
                        func canDisplay(_ text: String) -> Bool {
                                let nsText = text as NSString
                                var buffer = Array<unichar>(repeating: 0, count: nsText.length)
                                nsText.getCharacters(&buffer)
                                var glyphs = Array<CGGlyph>(repeating: 0, count: nsText.length)
                                let result = CTFontGetGlyphsForCharacters(font, &buffer, &glyphs, glyphs.count)
                                return result
                        }
                        let filteredEmojis: [[String]] = emojis.map { block -> [String] in
                                let newBlock: [String] = block.filter({ canDisplay($0) })
                                return newBlock
                        }
                        return filteredEmojis
                }
        }()
}
