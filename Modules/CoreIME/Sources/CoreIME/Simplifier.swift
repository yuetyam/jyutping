import Foundation
import SQLite3

struct Simplifier {

        private static func t2s(character: Character, statement: OpaquePointer?) -> Character {
                guard let code = character.unicodeScalars.first?.value else { return character }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                guard sqlite3_step(statement) == SQLITE_ROW else { return character }
                let simplifiedCode = Int(sqlite3_column_int64(statement, 0))
                guard let simplifiedCharacter = transfromCharacter(from: simplifiedCode) else { return character }
                return simplifiedCharacter
        }
        private static func convert(character: Character, statement: OpaquePointer?) -> String {
                guard let code = character.unicodeScalars.first?.value else { return String(character) }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                guard sqlite3_step(statement) == SQLITE_ROW else { return String(character) }
                let simplifiedCode = Int(sqlite3_column_int64(statement, 0))
                guard let simplifiedCharacter = transfromCharacter(from: simplifiedCode) else { return String(character) }
                return String(simplifiedCharacter)
        }
        private static func transfromCharacter(from code: Int) -> Character? {
                guard let scalar = Unicode.Scalar(code) else { return nil }
                return Character(scalar)
        }

        static func simplify(_ text: String, statement: OpaquePointer?) -> String {
                switch text.count {
                case 0:
                        return text
                case 1:
                        return String(t2s(character: text.first!, statement: statement))
                case 2:
                        return phrases[text] ?? String(text.map({ t2s(character: $0, statement: statement) }))
                default:
                        return phrases[text] ?? transform(text, statement: statement)
                }
        }

        private static func transform(_ text: String, statement: OpaquePointer?) -> String {
                let roundOne = replace(text, replacement: "W")
                guard roundOne.matched.isNotEmpty else {
                        return String(text.map({ t2s(character: $0, statement: statement) }))
                }

                let roundTwo = replace(roundOne.modified, replacement: "X")
                guard roundTwo.matched.isNotEmpty else {
                        let transformed = roundTwo.modified.map({ convert(character: $0, statement: statement) }).joined()
                        let reverted: String = transformed.replacingOccurrences(of: roundOne.replacement, with: roundOne.matched)
                        return reverted
                }

                let roundThree = replace(roundTwo.modified, replacement: "Y")
                guard roundThree.matched.isNotEmpty else {
                        let transformed: String = roundThree.modified.map({ convert(character: $0, statement: statement) }).joined()
                        let reverted: String = transformed
                                .replacingOccurrences(of: roundOne.replacement, with: roundOne.matched)
                                .replacingOccurrences(of: roundTwo.replacement, with: roundTwo.matched)
                        return reverted
                }

                let roundFour = replace(roundThree.modified, replacement: "Z")
                guard roundFour.matched.isNotEmpty else {
                        let transformed: String = roundFour.modified.map({ convert(character: $0, statement: statement) }).joined()
                        let reverted: String = transformed
                                .replacingOccurrences(of: roundOne.replacement, with: roundOne.matched)
                                .replacingOccurrences(of: roundTwo.replacement, with: roundTwo.matched)
                                .replacingOccurrences(of: roundThree.replacement, with: roundThree.matched)
                        return reverted
                }

                let transformed: String = roundFour.modified.map({ convert(character: $0, statement: statement) }).joined()
                let reverted: String = transformed
                        .replacingOccurrences(of: roundOne.replacement, with: roundOne.matched)
                        .replacingOccurrences(of: roundTwo.replacement, with: roundTwo.matched)
                        .replacingOccurrences(of: roundThree.replacement, with: roundThree.matched)
                        .replacingOccurrences(of: roundFour.replacement, with: roundFour.matched)
                return reverted
        }

        private static func replace(_ text: String, replacement: String) -> (modified: String, matched: String, replacement: String) {
                let textCount: Int = text.count
                let keys: [String] = phrases.keys.filter({ $0.count <= textCount }).sorted(by: { $0.count > $1.count })
                lazy var modified: String = text
                lazy var matched: String = ""
                for key in keys {
                        if text.hasPrefix(key) {
                                modified = text.replacingOccurrences(of: key, with: replacement)
                                matched = phrases[key]!
                                break
                        }
                }
                guard matched.isEmpty else {
                        return (modified, matched, replacement)
                }
                for key in keys {
                        if text.contains(key) {
                                modified = text.replacingOccurrences(of: key, with: replacement)
                                matched = phrases[key]!
                                break
                        }
                }
                return (modified, matched, replacement)
        }

private static let phrases: [String: String] = [
"一目瞭然": "一目了然",
"上鍊": "上链",
"不瞭解": "不了解",
"么麼": "幺麽",
"么麽": "幺麽",
"乾乾淨淨": "干干净净",
"乾乾脆脆": "干干脆脆",
"乾元": "乾元",
"乾卦": "乾卦",
"乾嘉": "乾嘉",
"乾圖": "乾图",
"乾坤": "乾坤",
"乾坤一擲": "乾坤一掷",
"乾坤再造": "乾坤再造",
"乾坤大挪移": "乾坤大挪移",
"乾宅": "乾宅",
"乾斷": "乾断",
"乾旦": "乾旦",
"乾曜": "乾曜",
"乾清宮": "乾清宫",
"乾盛世": "乾盛世",
"乾紅": "乾红",
"乾綱": "乾纲",
"乾縣": "乾县",
"乾象": "乾象",
"乾造": "乾造",
"乾道": "乾道",
"乾陵": "乾陵",
"乾隆": "乾隆",
"乾隆年間": "乾隆年间",
"乾隆皇帝": "乾隆皇帝",
"二噁英": "二𫫇英",
"以免藉口": "以免借口",
"以功覆過": "以功复过",
"侔德覆載": "侔德复载",
"傢俱": "家具",
"傷亡枕藉": "伤亡枕藉",
"八濛山": "八濛山",
"凌藉": "凌借",
"出醜狼藉": "出丑狼藉",
"函覆": "函复",
"千鍾粟": "千锺粟",
"反反覆覆": "反反复复",
"反覆": "反复",
"反覆思維": "反复思维",
"反覆思量": "反复思量",
"反覆性": "反复性",
"名覆金甌": "名复金瓯",
"哪吒": "哪吒",
"回覆": "回复",
"壺裏乾坤": "壶里乾坤",
"宫商角徵羽": "宫商角徵羽",
"射覆": "射复",
"尼乾子": "尼乾子",
"尼乾陀": "尼乾陀",
"幺麼": "幺麽",
"幺麼小丑": "幺麽小丑",
"幺麼小醜": "幺麽小丑",
"康乾": "康乾",
"彷彿": "仿佛",
"彷徨": "彷徨",
"徵弦": "徵弦",
"徵絃": "徵弦",
"徵羽摩柯": "徵羽摩柯",
"徵聲": "徵声",
"徵調": "徵调",
"徵音": "徵音",
"情有獨鍾": "情有独钟",
"憑藉": "凭借",
"憑藉着": "凭借着",
"手鍊": "手链",
"扭轉乾坤": "扭转乾坤",
"找藉口": "找借口",
"拉鍊": "拉链",
"拉鍊工程": "拉链工程",
"拜覆": "拜复",
"據瞭解": "据了解",
"文錦覆阱": "文锦复阱",
"於呼哀哉": "於呼哀哉",
"於菟": "於菟",
"於邑": "於邑",
"於陵子": "於陵子",
"旋乾轉坤": "旋乾转坤",
"旋轉乾坤": "旋转乾坤",
"旋轉乾坤之力": "旋转乾坤之力",
"明瞭": "明了",
"明覆": "明复",
"有序": "有序",
"朝乾夕惕": "朝乾夕惕",
"木吒": "木吒",
"李乾德": "李乾德",
"李澤鉅": "李泽钜",
"李鍊福": "李链福",
"李鍾郁": "李锺郁",
"樊於期": "樊於期",
"沈沒": "沉没",
"沈沒成本": "沉没成本",
"沈積": "沉积",
"沈船": "沉船",
"沈默": "沉默",
"流徵": "流徵",
"浪蕩乾坤": "浪荡乾坤",
"滑藉": "滑借",
"無序": "无序",
"牴牾": "抵牾",
"牴觸": "抵触",
"狐藉虎威": "狐借虎威",
"珍珠項鍊": "珍珠项链",
"甚鉅": "甚钜",
"申覆": "申复",
"畢昇": "毕昇",
"發覆": "发复",
"瞭如": "了如",
"瞭如指掌": "了如指掌",
"瞭望": "瞭望",
"瞭然": "了然",
"瞭然於心": "了然于心",
"瞭若指掌": "了若指掌",
"瞭解": "了解",
"瞭解到": "了解到",
"示覆": "示复",
"神祇": "神祇",
"稟覆": "禀复",
"竺乾": "竺乾",
"答覆": "答复",
"篤麼": "笃麽",
"簡單明瞭": "简单明了",
"籌畫": "筹划",
"素藉": "素借",
"老態龍鍾": "老态龙钟",
"肘手鍊足": "肘手链足",
"茵藉": "茵借",
"萬鍾": "万锺",
"蒜薹": "蒜薹",
"蕓薹": "芸薹",
"蕩覆": "荡复",
"蕭乾": "萧乾",
"藉代": "借代",
"藉以": "借以",
"藉助": "借助",
"藉助於": "借助于",
"藉卉": "借卉",
"藉口": "借口",
"藉喻": "借喻",
"藉寇兵": "借寇兵",
"藉寇兵齎盜糧": "借寇兵赍盗粮",
"藉手": "借手",
"藉據": "借据",
"藉故": "借故",
"藉故推辭": "借故推辞",
"藉方": "借方",
"藉條": "借条",
"藉槁": "借槁",
"藉機": "借机",
"藉此": "借此",
"藉此機會": "借此机会",
"藉甚": "借甚",
"藉由": "借由",
"藉着": "借着",
"藉端": "借端",
"藉端生事": "借端生事",
"藉箸代籌": "借箸代筹",
"藉草枕塊": "借草枕块",
"藉藉": "藉藉",
"藉藉无名": "藉藉无名",
"藉詞": "借词",
"藉讀": "借读",
"藉資": "借资",
"衹得": "只得",
"衹見樹木": "只见树木",
"袖裏乾坤": "袖里乾坤",
"覆上": "复上",
"覆住": "复住",
"覆信": "复信",
"覆冒": "复冒",
"覆呈": "复呈",
"覆命": "复命",
"覆墓": "复墓",
"覆宗": "复宗",
"覆帳": "复帐",
"覆幬": "复帱",
"覆成": "复成",
"覆按": "复按",
"覆文": "复文",
"覆杯": "复杯",
"覆校": "复校",
"覆瓿": "复瓿",
"覆盂": "复盂",
"覆盆": "覆盆",
"覆盆子": "覆盆子",
"覆盤": "覆盘",
"覆育": "复育",
"覆蕉尋鹿": "复蕉寻鹿",
"覆逆": "复逆",
"覆醢": "复醢",
"覆醬瓿": "复酱瓿",
"覆電": "复电",
"覆露": "复露",
"覆鹿尋蕉": "复鹿寻蕉",
"覆鹿遺蕉": "复鹿遗蕉",
"覆鼎": "复鼎",
"見覆": "见复",
"角徵": "角徵",
"角徵羽": "角徵羽",
"計畫": "计划",
"變徵": "变徵",
"變徵之聲": "变徵之声",
"變徵之音": "变徵之音",
"貂覆額": "貂复额",
"買臣覆水": "买臣复水",
"踅門瞭戶": "踅门了户",
"躪藉": "躏借",
"郭子乾": "郭子乾",
"酒逢知己千鍾少": "酒逢知己千锺少",
"醞藉": "酝借",
"重覆": "重复",
"金吒": "金吒",
"金鍊": "金链",
"鈞覆": "钧复",
"鉅子": "钜子",
"鉅萬": "钜万",
"鉅防": "钜防",
"鉸鍊": "铰链",
"銀鍊": "银链",
"錢鍾書": "钱锺书",
"鍊墜": "链坠",
"鍊子": "链子",
"鍊形": "链形",
"鍊條": "链条",
"鍊錘": "链锤",
"鍊鎖": "链锁",
"鍛鍾": "锻锺",
"鍾繇": "钟繇",
"鍾萬梅": "锺万梅",
"鍾重發": "锺重发",
"鍾鍛": "锺锻",
"鍾馗": "锺馗",
"鎖鍊": "锁链",
"鐵鍊": "铁链",
"鑽石項鍊": "钻石项链",
"雁杳魚沈": "雁杳鱼沉",
"雖覆能復": "虽覆能复",
"電覆": "电复",
"露覆": "露复",
"項鍊": "项链",
"頗覆": "颇复",
"頸鍊": "颈链",
"顛乾倒坤": "颠乾倒坤",
"顛倒乾坤": "颠倒乾坤",
"顧藉": "顾借",
"麼些族": "麽些族",
"黄鍾公": "黄锺公",
"龍鍾": "龙钟",
"甚麼": "什么"
]
}
