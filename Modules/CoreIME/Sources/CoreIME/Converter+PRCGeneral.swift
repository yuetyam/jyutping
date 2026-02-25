import Foundation
import SQLite3
import CommonExtensions

extension Converter {

        private static func char2char(character: Character, statement: OpaquePointer?) -> Character {
                guard let code = character.unicodeScalars.first?.value else { return character }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                guard sqlite3_step(statement) == SQLITE_ROW else { return character }
                let targetCode = Int(sqlite3_column_int64(statement, 0))
                return Character(decimal: targetCode) ?? character
        }

        /// Transform traditional Cantonese / Chinese text to the PRC General character standard.
        /// - Parameters:
        ///   - text: The source traditional Cantonese / Chinese characters.
        ///   - statement: SQLite3 statement pointer.
        /// - Returns: Converted text.
        static func prcGeneralConvert(_ text: String, statement: OpaquePointer?) -> String {
                switch text.count {
                case 0:
                        return text
                case 1:
                        return String(char2char(character: text.first!, statement: statement))
                case 2:
                        return phrases[text] ?? String(text.map({ char2char(character: $0, statement: statement) }))
                default:
                        return phrases[text] ?? transform(text, statement: statement)
                }
        }

        /// Convert traditional Cantonese / Chinese text to the PRC General character standard.
        /// Greedy left-to-right longest-match: at each position, try the longest phrase first; fall back to single-character conversion.
        /// - Parameters:
        ///   - text: The source traditional Cantonese / Chinese characters.
        ///   - statement: SQLite3 statement pointer.
        /// - Returns: Transformed text.
        private static func transform(_ text: String, statement: OpaquePointer?) -> String {
                let characters = Array(text)
                let charCount = characters.count
                var result = String()
                result.reserveCapacity(charCount)
                var index = 0
                while index < charCount {
                        var matched = false
                        let maxLength = min(maxPhraseLength, charCount - index)
                        for length in stride(from: maxLength, through: minPhraseLength, by: -1) {
                                let substring = String(characters[index..<(index + length)])
                                if let replacement = phrases[substring] {
                                        result += replacement
                                        index += length
                                        matched = true
                                        break
                                }
                        }
                        if matched.negative {
                                let char = characters[index]
                                if char.isIdeographic {
                                        result.append(char2char(character: characters[index], statement: statement))
                                } else {
                                        result.append(char)
                                }
                                index += 1
                        }
                }
                return result
        }

        private static let minPhraseLength: Int = 2
        private static let maxPhraseLength: Int = phrases.keys.map(\.count).max() ?? 4

private static let phrases: [String: String] = [

"上鍊": "上鏈",
"么麼": "幺麽",
"么麽": "幺麽",
"以功覆過": "以功覆過",
"侔德覆載": "侔德覆載",
"傢俱": "傢具",
"函覆": "函復",
"反反覆覆": "反反復復",
"反覆": "反復",
"反覆思維": "反復思維",
"反覆思量": "反復思量",
"反覆性": "反復性",
"名覆金甌": "名復金甌",
"哪吒": "哪吒",
"回覆": "回復",
"射覆": "射覆",
"彷彿": "仿佛",
"彷徨": "彷徨",
"手鍊": "手鏈",
"拉鍊": "拉鏈",
"拉鍊工程": "拉鏈工程",
"拜覆": "拜復",
"文錦覆阱": "文錦覆阱",
"於世成": "於世成",
"於乎": "於乎",
"於仲完": "於仲完",
"於倫": "於倫",
"於其一": "於其一",
"於則": "於則",
"於勇明": "於勇明",
"於呼哀哉": "於呼哀哉",
"於單": "於單",
"於坦": "於坦",
"於崇文": "於崇文",
"於忠祥": "於忠祥",
"於惟一": "於惟一",
"於戲": "於戲",
"於敖": "於敖",
"於梨華": "於梨華",
"於清言": "於清言",
"於潛": "於潜",
"於琳": "於琳",
"於穆": "於穆",
"於竹屋": "於竹屋",
"於菟": "於菟",
"於邑": "於邑",
"於陵子": "於陵子",
"明覆": "明復",
"木吒": "木吒",
"李澤鉅": "李澤鉅",
"李鍊福": "李鏈福",
"束脩": "束脩",
"樊於期": "樊於期",
"沈沒": "沉没",
"沈沒成本": "沉没成本",
"沈積": "沉積",
"沈船": "沉船",
"沈默": "沉默",
"珍珠項鍊": "珍珠項鏈",
"甚鉅": "甚鉅",
"申覆": "申復",
"畢昇": "畢昇",
"發覆": "發覆",
"示覆": "示復",
"稟覆": "禀復",
"答覆": "答復",
"肘手鍊足": "肘手鏈足",
"脩敬": "脩敬",
"脩脯": "脩脯",
"脩金": "脩金",
"蕩覆": "蕩覆",
"覆上": "覆上",
"覆住": "覆住",
"覆信": "復信",
"覆冒": "覆冒",
"覆呈": "復呈",
"覆命": "復命",
"覆墓": "復墓",
"覆宗": "覆宗",
"覆帳": "復帳",
"覆幬": "覆幬",
"覆成": "覆成",
"覆按": "復按",
"覆文": "復文",
"覆杯": "覆杯",
"覆校": "復校",
"覆瓿": "覆瓿",
"覆盂": "覆盂",
"覆盆": "覆盆",
"覆盆子": "覆盆子",
"覆盤": "覆盤",
"覆育": "覆育",
"覆蕉尋鹿": "覆蕉尋鹿",
"覆逆": "覆逆",
"覆醢": "覆醢",
"覆醬瓿": "覆醬瓿",
"覆電": "復電",
"覆露": "覆露",
"覆鹿尋蕉": "覆鹿尋蕉",
"覆鹿遺蕉": "覆鹿遺蕉",
"覆鼎": "覆鼎",
"見覆": "見復",
"貂覆額": "貂覆額",
"買臣覆水": "買臣覆水",
"重覆": "重復",
"金吒": "金吒",
"金鍊": "金鏈",
"鈞覆": "鈞復",
"鉅子": "鉅子",
"鉅萬": "鉅萬",
"鉅防": "鉅防",
"鉸鍊": "鉸鏈",
"銀鍊": "銀鏈",
"鍊墜": "鏈墜",
"鍊子": "鏈子",
"鍊形": "鏈形",
"鍊條": "鏈條",
"鍊錘": "鏈錘",
"鍊鎖": "鏈鎖",
"鎖鍊": "鎖鏈",
"鐵鍊": "鐵鏈",
"鑽石項鍊": "鑽石項鏈",
"雁杳魚沈": "雁杳魚沉",
"雖覆能復": "雖覆能復",
"電覆": "電復",
"露覆": "露覆",
"項鍊": "項鏈",
"頗覆": "頗覆",
"頸鍊": "頸鏈",

]

}

