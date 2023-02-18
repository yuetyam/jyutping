import UIKit
import CoreIME

struct Emoji {

        private static let key: String = "emoji_frequent"
        private(set) static var frequent: [String] = {
                let history: String = UserDefaults.standard.string(forKey: key) ?? .empty
                if history.isEmpty {
                        return EmojiSource.defaultFrequent
                } else if history.contains(",") {
                        return history.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
                } else {
                        return history.map({ String($0) })
                }
        }()
        static func updateFrequent(latest emoji: String) {
                let combined: [String] = ([emoji] + frequent).uniqued()
                let updated: [String] = combined.count <= 30 ? combined : combined.dropLast(combined.count - 30)
                frequent = updated
                let frequentText: String = updated.joined(separator: ",")
                UserDefaults.standard.set(frequentText, forKey: key)
        }
        static func clearFrequent() {
                frequent = EmojiSource.defaultFrequent
                let emptyText: String = ""
                UserDefaults.standard.set(emptyText, forKey: key)
        }

        static let sequences: [[String]] = {
                let emojis: [[String]] = EmojiSource.fetchAll()
                if #available(iOSApplicationExtension 15.4, *) {
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
