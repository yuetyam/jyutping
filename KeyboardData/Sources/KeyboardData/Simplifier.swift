import Foundation
import SQLite3

public struct Simplifier {
        private let database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "t2s", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()

        private func match(_ text: String) -> String {
                let code: UInt32 = text.first?.unicodeScalars.first?.value ?? 0
                let queryString = "SELECT simplified FROM t2stable WHERE traditional = \(code);"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        if sqlite3_step(queryStatement) == SQLITE_ROW {
                                let simplified: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                return simplified
                        }
                }
                return text
        }
        private func matchCharacter(_ character: Character) -> String {
                let code: UInt32 = character.unicodeScalars.first?.value ?? 0
                let queryString = "SELECT simplified FROM t2stable WHERE traditional = \(code);"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        if sqlite3_step(queryStatement) == SQLITE_ROW {
                                let simplified: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                return simplified
                        }
                }
                return String(character)
        }

        public init() {}
        public func close() {
                sqlite3_close_v2(database)
        }

        public func convert(_ text: String) -> String {
                switch text.count {
                case 0:
                        return text
                case 1:
                        return match(text)
                default:
                        let replaced = replace(text)
                        guard replaced.modified.count != 1 else { return replaced.matched }
                        let newCharacters: [String] = replaced.modified.map({ matchCharacter($0) })
                        let newText: String = newCharacters.joined()
                        if replaced.matched.isEmpty {
                                return newText
                        } else {
                                let replaceBacked: String = newText.replacingOccurrences(of: "X", with: replaced.matched)
                                return replaced.step2.isEmpty ? replaceBacked : replaceBacked.replacingOccurrences(of: "Y", with: replaced.step2)
                        }
                }
        }

        private func replace(_ text: String) -> (modified: String, matched: String, step2: String) {
                let possibleKeys: [String] = Simplifier.phrases.keys.filter({ $0.count <= text.count }).sorted(by: { $0.count > $1.count })
                lazy var replaced: String = text
                lazy var matched: String = ""
                for item in possibleKeys {
                        if text.contains(item) {
                                replaced = text.replacingOccurrences(of: item, with: "X")
                                matched = Simplifier.phrases[item]!
                                break
                        }
                }
                let isDone: Bool = matched.isEmpty || replaced.count == 1
                guard !isDone else {
                        return (replaced, matched, "")
                }
                lazy var step2Replaced: String = replaced
                lazy var step2Matched: String = ""
                for item in possibleKeys {
                        if replaced.contains(item) {
                                step2Replaced = replaced.replacingOccurrences(of: item, with: "Y")
                                step2Matched = Simplifier.phrases[item]!
                                break
                        }
                }
                return (step2Replaced, matched, step2Matched)
        }




private static let phrases: [String: String] = [
"酒逢知己千鍾少話不投機半句多": "酒逢知己千锺少话不投机半句多",
"大目乾連冥間救母變文": "大目乾连冥间救母变文",
"衹見樹木不見森林": "只见树木不见森林",
"酒逢知己千鍾少": "酒逢知己千锺少",
"書中自有千鍾粟": "书中自有千锺粟",
"藉寇兵齎盜糧": "借寇兵赍盗粮",
"旋轉乾坤之力": "旋转乾坤之力",
"宫商角徵羽": "宫商角徵羽",
"乾坤大挪移": "乾坤大挪移",
"顛倒乾坤": "颠倒乾坤",
"顛乾倒坤": "颠乾倒坤",
"雖覆能復": "虽覆能复",
"雁杳魚沈": "雁杳鱼沉",
"鑽石項鍊": "钻石项链",
"踅門瞭戶": "踅门了户",
"買臣覆水": "买臣复水",
"變徵之音": "变徵之音",
"變徵之聲": "变徵之声",
"覆鹿遺蕉": "复鹿遗蕉",
"覆鹿尋蕉": "复鹿寻蕉",
"覆蕉尋鹿": "复蕉寻鹿",
"袖裏乾坤": "袖里乾坤",
"衹見樹木": "只见树木",
"藉藉无名": "藉藉无名",
"藉草枕塊": "借草枕块",
"藉箸代籌": "借箸代筹",
"藉端生事": "借端生事",
"藉此機會": "借此机会",
"藉故推辭": "借故推辞",
"肘手鍊足": "肘手链足",
"老態龍鍾": "老态龙钟",
"簡單明瞭": "简单明了",
"瞭若指掌": "了若指掌",
"瞭然於心": "了然于心",
"瞭如指掌": "了如指掌",
"盼既示覆": "盼既示复",
"珍珠項鍊": "珍珠项链",
"狐藉虎威": "狐借虎威",
"浪蕩乾坤": "浪荡乾坤",
"沈沒成本": "沉没成本",
"朝乾夕惕": "朝乾夕惕",
"旋轉乾坤": "旋转乾坤",
"旋乾轉坤": "旋乾转坤",
"於呼哀哉": "於呼哀哉",
"文錦覆阱": "文锦复阱",
"拉鍊工程": "拉链工程",
"扭轉乾坤": "扭转乾坤",
"情有獨鍾": "情有独钟",
"徵羽摩柯": "徵羽摩柯",
"幺麼小醜": "幺麽小丑",
"幺麼小丑": "幺麽小丑",
"壺裏乾坤": "壶里乾坤",
"名覆金甌": "名复金瓯",
"反覆思量": "反复思量",
"反覆思維": "反复思维",
"反反覆覆": "反反复复",
"出醜狼藉": "出丑狼藉",
"傷亡枕藉": "伤亡枕藉",
"侔德覆載": "侔德复载",
"以功覆過": "以功复过",
"以免藉口": "以免借口",
"乾隆皇帝": "乾隆皇帝",
"乾隆年間": "乾隆年间",
"乾坤再造": "乾坤再造",
"乾坤一擲": "乾坤一掷",
"乾乾脆脆": "干干脆脆",
"乾乾淨淨": "干干净净",
"一目瞭然": "一目了然",
"黄鍾公": "黄锺公",
"麼些族": "麽些族",
"鍾重發": "锺重发",
"鍾萬梅": "锺万梅",
"錢鍾書": "钱锺书",
"郭子乾": "郭子乾",
"貂覆額": "貂复额",
"角徵羽": "角徵羽",
"覆醬瓿": "复酱瓿",
"覆盆子": "覆盆子",
"藉寇兵": "借寇兵",
"藉助於": "借助于",
"瞭解到": "了解到",
"樊於期": "樊於期",
"李鍾郁": "李锺郁",
"李鍊福": "李链福",
"李澤鉅": "李泽钜",
"李乾德": "李乾德",
"於陵子": "於陵子",
"於竹屋": "於竹屋",
"於清言": "於清言",
"於梨華": "於梨华",
"於惟一": "於惟一",
"於忠祥": "於忠祥",
"於崇文": "於崇文",
"於勇明": "於勇明",
"於其一": "於其一",
"於仲完": "於仲完",
"於世成": "於世成",
"據瞭解": "据了解",
"找藉口": "找借口",
"憑藉着": "凭借着",
"張法乾": "张法乾",
"尼乾陀": "尼乾陀",
"反覆性": "反复性",
"千鍾粟": "千锺粟",
"八濛山": "八濛山",
"乾盛世": "乾盛世",
"乾清宮": "乾清宫",
"不瞭解": "不了解",
"龍鍾": "龙钟",
"顧藉": "顾借",
"頸鍊": "颈链",
"頗覆": "颇复",
"項鍊": "项链",
"露覆": "露复",
"電覆": "电复",
"鐵鍊": "铁链",
"鎖鍊": "锁链",
"鍾馗": "锺馗",
"鍾鍛": "锺锻",
"鍾繇": "钟繇",
"鍛鍾": "锻锺",
"鍊鎖": "链锁",
"鍊錘": "链锤",
"鍊條": "链条",
"鍊形": "链形",
"鍊子": "链子",
"鍊墜": "链坠",
"銀鍊": "银链",
"鉸鍊": "铰链",
"鉅防": "钜防",
"鉅萬": "钜万",
"鉅子": "钜子",
"鈞覆": "钧复",
"金鍊": "金链",
"金吒": "金吒",
"重覆": "重复",
"醞藉": "酝借",
"躪藉": "躏借",
"變徵": "变徵",
"計畫": "计划",
"角徵": "角徵",
"見覆": "见复",
"覆鼎": "复鼎",
"覆露": "复露",
"覆電": "复电",
"覆醢": "复醢",
"覆逆": "复逆",
"覆育": "复育",
"覆盤": "覆盘",
"覆盆": "覆盆",
"覆盂": "复盂",
"覆瓿": "复瓿",
"覆校": "复校",
"覆杯": "复杯",
"覆文": "复文",
"覆按": "复按",
"覆成": "复成",
"覆幬": "复帱",
"覆帳": "复帐",
"覆宗": "复宗",
"覆墓": "复墓",
"覆命": "复命",
"覆呈": "复呈",
"覆冒": "复冒",
"覆信": "复信",
"覆住": "复住",
"覆上": "复上",
"衹得": "只得",
"藉資": "借资",
"藉讀": "借读",
"藉詞": "借词",
"藉藉": "藉藉",
"藉端": "借端",
"藉着": "借着",
"藉由": "借由",
"藉甚": "借甚",
"藉此": "借此",
"藉機": "借机",
"藉槁": "借槁",
"藉條": "借条",
"藉方": "借方",
"藉故": "借故",
"藉據": "借据",
"藉手": "借手",
"藉喻": "借喻",
"藉口": "借口",
"藉卉": "借卉",
"藉助": "借助",
"藉以": "借以",
"藉代": "借代",
"蕭乾": "萧乾",
"蕩覆": "荡复",
"蕓薹": "芸薹",
"蒜薹": "蒜薹",
"萬鍾": "万锺",
"茵藉": "茵借",
"素藉": "素借",
"籌畫": "筹划",
"篤麼": "笃麽",
"答覆": "答复",
"稟覆": "禀复",
"神祇": "神祇",
"示覆": "示复",
"瞭解": "了解",
"瞭然": "了然",
"瞭望": "瞭望",
"瞭如": "了如",
"發覆": "发复",
"畢昇": "毕昇",
"申覆": "申复",
"甚鉅": "甚钜",
"牴觸": "抵触",
"牴牾": "抵牾",
"無序": "无序",
"滑藉": "滑借",
"流徵": "流徵",
"沈默": "沉默",
"沈船": "沉船",
"沈積": "沉积",
"沈沒": "沉没",
"木吒": "木吒",
"有序": "有序",
"明覆": "明复",
"明瞭": "明了",
"於邑": "於邑",
"於菟": "於菟",
"於穆": "於穆",
"於琳": "於琳",
"於潛": "於潜",
"於敖": "於敖",
"於戲": "於戏",
"於坦": "於坦",
"於單": "於单",
"於則": "於则",
"於倫": "於伦",
"於乎": "於乎",
"拜覆": "拜复",
"拉鍊": "拉链",
"手鍊": "手链",
"憑藉": "凭借",
"徵音": "徵音",
"徵調": "徵调",
"徵聲": "徵声",
"徵絃": "徵弦",
"徵弦": "徵弦",
"彷徨": "彷徨",
"彷彿": "仿佛",
"康乾": "康乾",
"幺麼": "幺麽",
"射覆": "射复",
"回覆": "回复",
"哪吒": "哪吒",
"反覆": "反复",
"函覆": "函复",
"凌藉": "凌借",
"傢俱": "家具",
"乾隆": "乾隆",
"乾陵": "乾陵",
"乾道": "乾道",
"乾造": "乾造",
"乾象": "乾象",
"乾縣": "乾县",
"乾綱": "乾纲",
"乾紅": "乾红",
"乾曜": "乾曜",
"乾旦": "乾旦",
"乾斷": "乾断",
"乾宅": "乾宅",
"乾坤": "乾坤",
"乾圖": "乾图",
"乾嘉": "乾嘉",
"乾卦": "乾卦",
"乾元": "乾元",
"么麽": "幺麽",
"么麼": "幺麽",
"上鍊": "上链"
]


}

