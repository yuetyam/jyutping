import Foundation
import SQLite3
import CommonExtensions

extension Converter {

        /// Merge and normalize multiple candidate sources into a single list.
        /// - Parameters:
        ///   - memory: Candidates from InputMemory — all Cantonese.
        ///   - defined: User-defined candidates from System Text Replacements — all plain text.
        ///   - marks: TextMark candidates suggested by the Engine — all plain text.
        ///   - symbols: Emoji / symbol candidates suggested by the Engine.
        ///   - queried: Candidates suggested by the Engine — all Cantonese.
        ///   - isEmojiSuggestionsOn: Whether emoji and symbol candidates are needs. If `true`, include `symbols`; otherwise, exclude emojis/symbols.
        ///   - characterStandard: The Chinese character set to use (e.g., Traditional or Simplified).
        /// - Returns: A merged array of unique, converted candidates.
        public static func dispatch(memory: [Candidate], defined: [Candidate], marks: [Candidate], symbols: [Candidate], queried: [Candidate], isEmojiSuggestionsOn: Bool, characterStandard: CharacterStandard) -> [Candidate] {
                switch (memory.isNotEmpty, isEmojiSuggestionsOn) {
                case (true, true):
                        guard symbols.isNotEmpty else {
                                return (defined + memory + marks + queried.filter(\.isCompound.negative))
                                        .transformed(to: characterStandard)
                                        .distinct()
                        }
                        var items: [Candidate] = (defined + memory + marks + queried.filter(\.isCompound.negative))
                                .transformed(to: characterStandard)
                                .distinct()
                        for symbol in symbols.reversed() {
                                if let index = items.firstIndex(where: { $0.isCantonese && $0.lexiconText == symbol.lexiconText && $0.romanization == symbol.romanization }) {
                                        items.insert(symbol, at: index + 1)
                                }
                        }
                        return items
                case (true, false):
                        return (defined + memory + marks + queried.filter(\.isCompound.negative))
                                .transformed(to: characterStandard)
                                .distinct()
                case (false, true):
                        guard queried.isNotEmpty else {
                                return (defined + marks).distinct()
                        }
                        guard symbols.isNotEmpty else {
                                return (defined + marks + queried.transformed(to: characterStandard)).distinct()
                        }
                        var items: [Candidate] = queried
                        for symbol in symbols.reversed() {
                                if let index = items.firstIndex(where: { $0.lexiconText == symbol.lexiconText && $0.romanization == symbol.romanization }) {
                                        items.insert(symbol, at: index + 1)
                                }
                        }
                        return (defined + marks + items.transformed(to: characterStandard)).distinct()
                case (false, false):
                        return (defined + marks + queried.transformed(to: characterStandard)).distinct()
                }
        }
}

extension RandomAccessCollection where Element == Candidate {

        /// Convert Cantonese Candidate text to the specific variant
        /// - Parameter variant: Character variant
        /// - Returns: Transformed Candidates
        public func transformed(to variant: CharacterStandard) -> [Candidate] {
                switch variant {
                case .preset, .custom, .inherited, .etymology, .opencc:
                        return (self is Array<Candidate>) ? (self as! Array<Candidate>) : Array<Candidate>(self)
                case .hongkong:
                        return self.map { origin -> Candidate in
                                guard origin.isCantonese else { return origin }
                                let convertedText: String = Converter.convert2HongKongVariant(origin.lexiconText)
                                return Candidate(text: convertedText, lexiconText: origin.lexiconText, romanization: origin.romanization, input: origin.input, mark: origin.mark, order: origin.order)
                        }
                case .taiwan:
                        return self.map { origin -> Candidate in
                                guard origin.isCantonese else { return origin }
                                let convertedText: String = Converter.convert2TaiwanVariant(origin.lexiconText)
                                return Candidate(text: convertedText, lexiconText: origin.lexiconText, romanization: origin.romanization, input: origin.input, mark: origin.mark, order: origin.order)
                        }
                case .prcGeneral:
                        return self.map { origin -> Candidate in
                                guard origin.isCantonese else { return origin }
                                let convertedText: String = Converter.convert2PRCGeneralVariant(origin.lexiconText)
                                return Candidate(text: convertedText, lexiconText: origin.lexiconText, romanization: origin.romanization, input: origin.input, mark: origin.mark, order: origin.order)
                        }
                case .ancientBooksPublishing:
                        return (self is Array<Candidate>) ? (self as! Array<Candidate>) : Array<Candidate>(self)
                case .mutilated:
                        let statement: OpaquePointer? = {
                                let query: String = "SELECT simplified FROM t2stable WHERE traditional = ?;"
                                var pointer: OpaquePointer? = nil
                                guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                                return pointer
                        }()
                        defer { sqlite3_finalize(statement) }
                        return self.map { origin -> Candidate in
                                guard origin.isCantonese else { return origin }
                                let convertedText: String = Simplifier.simplify(origin.lexiconText, statement: statement)
                                return Candidate(text: convertedText, lexiconText: origin.lexiconText, romanization: origin.romanization, input: origin.input, mark: origin.mark, order: origin.order)
                        }
                }
        }
}

/// Character Variant Converter
public struct Converter {

        /// Convert original (traditional) text to the specific variant
        /// - Parameters:
        ///   - text: Original (traditional) text
        ///   - variant: Character Variant
        /// - Returns: Converted text
        public static func convert(_ text: String, to variant: CharacterStandard) -> String {
                switch variant {
                case .preset, .custom, .inherited, .etymology, .opencc:
                        return text
                case .hongkong:
                        return convert2HongKongVariant(text)
                case .taiwan:
                        return convert2TaiwanVariant(text)
                case .prcGeneral:
                        return convert2PRCGeneralVariant(text)
                case .ancientBooksPublishing:
                        return text
                case .mutilated:
                        let statement: OpaquePointer? = {
                                let query: String = "SELECT simplified FROM t2stable WHERE traditional = ?;"
                                var pointer: OpaquePointer? = nil
                                guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                                return pointer
                        }()
                        defer { sqlite3_finalize(statement) }
                        return Simplifier.simplify(text, statement: statement)
                }
        }

        fileprivate static func convert2HongKongVariant(_ text: String) -> String {
                switch text.count {
                case 0:
                        return text
                case 1:
                        return hongkongVariants[text] ?? text
                default:
                        let converted = text.map({ hongkongCharacterVariants[$0] ?? $0 })
                        return String(converted)
                }
        }
        fileprivate static func convert2TaiwanVariant(_ text: String) -> String {
                switch text.count {
                case 0:
                        return text
                case 1:
                        return taiwanVariants[text] ?? text
                default:
                        let converted: [Character] = text.map({ taiwanCharacterVariants[$0] ?? $0 })
                        return String(converted)
                }
        }
        fileprivate static func convert2PRCGeneralVariant(_ text: String) -> String {
                switch text.count {
                case 0:
                        return text
                case 1:
                        return prcGeneralVariants[text] ?? text
                default:
                        let converted: [Character] = text.map({ prcGeneralCharacterVariants[$0] ?? $0 })
                        return String(converted)
                }
        }

        private static let hongkongVariants: [String: String] = {
                let keys: [String] = hongkongCharacterVariants.keys.map({ String($0) })
                let values: [String] = hongkongCharacterVariants.values.map({ String($0) })
                let newDictionary: [String: String] = Dictionary(uniqueKeysWithValues: zip(keys, values))
                return newDictionary
        }()
        private static let taiwanVariants: [String: String] = {
                let keys: [String] = taiwanCharacterVariants.keys.map({ String($0) })
                let values: [String] = taiwanCharacterVariants.values.map({ String($0) })
                let newDictionary: [String: String] = Dictionary(uniqueKeysWithValues: zip(keys, values))
                return newDictionary
        }()
        private static let prcGeneralVariants: [String: String] = {
                let keys: [String] = prcGeneralCharacterVariants.keys.map({ String($0) })
                let values: [String] = prcGeneralCharacterVariants.values.map({ String($0) })
                let newDictionary: [String: String] = Dictionary(uniqueKeysWithValues: zip(keys, values))
                return newDictionary
        }()


private static let hongkongCharacterVariants: [Character: Character] = [
"僞": "偽",
"兌": "兑",
"叄": "叁",
// "喫": "吃",
"囪": "囱",
"媼": "媪",
"嬀": "媯",
"悅": "悦",
"慍": "愠",
"戶": "户",
"挩": "捝",
"搵": "揾",
"擡": "抬",
"敓": "敚",
"敘": "敍",
"柺": "枴",
"梲": "棁",
"棱": "稜",
"榲": "榅",
"檯": "枱",
"氳": "氲",
"涗": "涚",
"溫": "温",
"溼": "濕",
"潙": "溈",
"潨": "潀",
"熅": "煴",
"爲": "為",
"癡": "痴",
"皁": "皂",
"祕": "秘",
"稅": "税",
"竈": "灶",
"糉": "粽",
"縕": "緼",
"纔": "才",
"脣": "唇",
"脫": "脱",
"膃": "腽",
"臥": "卧",
"臺": "台",
"菸": "煙",
"蒕": "蒀",
"蔥": "葱",
"蔿": "蒍",
"蘊": "藴",
"蛻": "蜕",
"衆": "眾",
"衛": "衞",
"覈": "核",
"說": "説",
"踊": "踴",
"轀": "輼",
"醞": "醖",
"鉢": "缽",
"鉤": "鈎",
"銳": "鋭",
"鍼": "針",
"閱": "閲",
"鰮": "鰛"
]

private static let taiwanCharacterVariants: [Character: Character] = [
"僞": "偽",
"啓": "啟",
// "喫": "吃",
"嫺": "嫻",
"嬀": "媯",
"峯": "峰",
"幺": "么",
"擡": "抬",
"棱": "稜",
"檐": "簷",
"污": "汙",
"泄": "洩",
"潙": "溈",
"潨": "潀",
"爲": "為",
"牀": "床",
"痹": "痺",
"癡": "痴",
"皁": "皂",
"着": "著",
"睾": "睪",
"祕": "秘",
"竈": "灶",
"糉": "粽",
"繮": "韁",
"纔": "才",
"羣": "群",
"脣": "唇",
"蔘": "參",
"蔿": "蒍",
"衆": "眾",
"裏": "裡",
"覈": "核",
"踊": "踴",
"鉢": "缽",
"鍼": "針",
"鮎": "鯰",
"麪": "麵",
"齶": "顎"
]


private static let prcGeneralCharacterVariants: [Character: Character] = [
"丟": "丢",
"並": "并",
"亙": "亘",
"佇": "伫",
"佈": "布",
"佔": "占",
"併": "并",
"侶": "侣",
"侷": "局",
"俁": "俣",
"俬": "私",
"倖": "幸",
"傑": "杰",
"傯": "偬",
"僱": "雇",
"儁": "俊",
"兇": "凶",
"兌": "兑",
"兗": "兖",
"內": "内",
"冊": "册",
"冑": "胄",
"冪": "幂",
"凈": "净",
"凜": "凛",
"別": "别",
"刪": "删",
"剎": "刹",
"剝": "剥",
"剷": "鏟",
"勳": "勛",
"勻": "匀",
"卹": "恤",
"卻": "却",
"卽": "即",
"厤": "曆",
"只": "衹",
// "吒": "咤 吒",
"吳": "吴",
"吶": "呐",
"呂": "吕",
"唸": "念",
"啟": "啓",
"喚": "唤",
// "喫": "吃",
"噓": "嘘",
"嚐": "嘗",
"嚥": "咽",
"囪": "囱",
"埰": "采",
"塚": "冢",
"墰": "罎",
"壈": "𡒄",
"壎": "塤",
"壜": "罎",
"夠": "够",
"奐": "奂",
"奧": "奥",
"奼": "姹",
"姍": "姗",
"姦": "奸",
"姪": "侄",
"娛": "娱",
"媯": "嬀",
"媼": "媪",
"嫋": "裊",
"嫺": "嫻",
"嬤": "嬷",
"孃": "娘",
"宮": "宫",
"寀": "采",
"屆": "届",
"屍": "尸",
"屜": "屉",
"峯": "峰",
"崑": "昆",
"崙": "侖",
"崢": "峥",
"嵗": "歲",
"嶴": "岙",
"嶽": "岳",
"巖": "岩",
"巹": "卺",
"廁": "厠",
"廂": "厢",
"廄": "厩",
"廈": "厦",
"廕": "蔭",
"廚": "厨",
"廝": "厮",
"廩": "廪",
"弒": "弑",
"弔": "吊",
"強": "强",
"彔": "录",
"彥": "彦",
"彫": "雕",
// "彷": "彷 仿",
"彿": "佛",
"恆": "恒",
"恥": "耻",
"悅": "悦",
"悞": "悮",
"悽": "凄",
"愨": "慤",
"慄": "栗",
"慍": "愠",
"慼": "戚",
"慾": "欲",
"懍": "懔",
"戩": "戬",
"戱": "戲",
"戶": "户",
"拋": "抛",
"挩": "捝",
"挱": "挲",
"捱": "挨",
"掙": "挣",
"掛": "挂",
"採": "采",
"換": "换",
"揯": "搄",
"搖": "摇",
"搵": "揾",
"撐": "撑",
"擡": "抬",
"擣": "搗",
"攜": "携",
"敎": "教",
"敓": "敚",
"敘": "叙",
// "於": "于 於",
"於": "于",
"旂": "旗",
"旣": "既",
// "昇": "升 昇",
"昇": "升",
"晉": "晋",
"曏": "嚮",
"朮": "术",
"杴": "鍁",
"枴": "拐",
"柵": "栅",
"柺": "拐",
"査": "查",
"桿": "杆",
"梔": "栀",
"梲": "棁",
"棄": "弃",
"棊": "棋",
"棲": "栖",
"榘": "矩",
"榦": "幹",
"榲": "榅",
"槓": "杠",
"槨": "椁",
"槼": "規",
"樑": "梁",
"樧": "榝",
"橫": "横",
"檁": "檩",
"檾": "苘",
"櫥": "橱",
"櫫": "橥",
"櫱": "蘖",
"櫺": "欞",
"欅": "櫸",
"歎": "嘆",
"歿": "殁",
"殭": "僵",
"殼": "殻",
"毀": "毁",
"氂": "牦",
"氳": "氲",
// "氾": "泛 氾",
"氾": "泛",
"汎": "泛",
"汙": "污",
"決": "决",
"沒": "没",
"沖": "冲",
"況": "况",
"泝": "溯",
"洩": "泄",
"洶": "汹",
"涗": "涚",
"涼": "凉",
"淒": "凄",
"淚": "泪",
"淥": "渌",
"淨": "净",
"淩": "凌",
"渙": "涣",
"減": "减",
"湊": "凑",
"湧": "涌",
"溈": "潙",
"溫": "温",
"溼": "濕",
"滙": "匯",
"滾": "滚",
"漵": "溆",
"潛": "潜",
"瀦": "潴",
"灩": "灧",
"災": "灾",
"為": "爲",
"煙": "烟",
"煥": "焕",
"熅": "煴",
"燉": "炖",
"燬": "毁",
"燻": "熏",
"爭": "争",
"牀": "床",
"牆": "墻",
"牠": "它",
"牴": "抵",
"犛": "牦",
"猙": "狰",
"獃": "呆",
"獎": "奬",
"琱": "雕",
"琺": "珐",
"瑤": "瑶",
"璿": "璇",
"甕": "瓮",
"產": "産",
// "甦": "蘇 甦",
// "甯": "寧 甯",
"異": "异",
"畵": "畫",
"疊": "叠",
"痠": "酸",
"痾": "疴",
"瘉": "愈",
"瘓": "痪",
"瘺": "瘻",
"癒": "愈",
"癡": "痴",
"皁": "皂",
"皰": "疱",
"盃": "杯",
"盜": "盗",
"盪": "蕩",
"眞": "真",
"眥": "眦",
"眾": "衆",
"睜": "睁",
"瞇": "眯",
"碕": "埼",
// "祕": "秘 祕",
"祕": "秘",
"祿": "禄",
"禿": "秃",
"秈": "籼",
"稅": "税",
"稈": "秆",
"稜": "棱",
"稟": "禀",
"窯": "窑",
"竚": "伫",
"筍": "笋",
"箇": "個",
"箏": "筝",
"簑": "蓑",
"粵": "粤",
"糉": "粽",
"紮": "扎",
"絃": "弦",
"絕": "絶",
"絛": "縧",
"綑": "捆",
"綠": "緑",
"綵": "彩",
// "線": "綫 線",
"線": "綫",
"縕": "緼",
"繃": "綳",
"繈": "襁",
"繐": "穗",
"繡": "綉",
"缽": "鉢",
"罈": "罎",
"罵": "駡",
"羋": "芈",
"羣": "群",
"羨": "羡",
"羶": "膻",
"翫": "玩",
"脈": "脉",
"脣": "唇",
// "脩": "修 脩",
"脫": "脱",
"腳": "脚",
"膃": "腽",
"臥": "卧",
"舘": "館",
"艣": "櫓",
"茲": "兹",
"荊": "荆",
"菴": "庵",
"菸": "烟",
"蒍": "蔿",
// "蒐": "搜 蒐",
"蒕": "蒀",
"蒞": "莅",
"蓆": "席",
"蓴": "蒓",
"蔉": "蓘",
"蔘": "參",
"蔥": "葱",
"薀": "蕰",
"蘊": "藴",
"虆": "蔂",
"虛": "虚",
"虯": "虬",
"蛻": "蜕",
"蝟": "猬",
"蝨": "虱",
"蠍": "蝎",
"蠔": "蚝",
"衕": "同",
"衚": "胡",
"袞": "衮",
"裡": "裏",
"襉": "襇",
// "覆": "覆 復",
"覈": "核",
"託": "托",
"註": "注",
"詠": "咏",
"誌": "志",
"說": "説",
"諡": "謚",
// "諮": "咨 諮",
"諮": "咨",
"謠": "謡",
"譁": "嘩",
"譟": "噪",
"譭": "毁",
"譾": "謭",
"讌": "宴",
"讚": "贊",
"豎": "竪",
"豔": "艷",
"豬": "猪",
"貍": "狸",
"貓": "猫",
"贓": "贜",
"贗": "贋",
"跡": "迹",
"跼": "局",
"踰": "逾",
"蹟": "迹",
"蹠": "跖",
"蹤": "踪",
"躕": "蹰",
"輓": "挽",
"轀": "輼",
"週": "周",
"遊": "游",
"遙": "遥",
"遡": "溯",
"醃": "腌",
"醞": "醖",
"醣": "糖",
// "釐": "厘 釐",
"釦": "扣",
// "鉅": "巨 鉅",
"鉤": "鈎",
"銳": "鋭",
"錄": "録",
// "鍊": "煉 鏈",
"鍼": "針",
"鎌": "鐮",
"鎚": "錘",
"鎭": "鎮",
"鏚": "戚",
"鏽": "銹",
"鐗": "鐧",
"鐫": "鎸",
"鑑": "鑒",
"钁": "鐝",
"閒": "閑",
"閗": "鬥",
"閱": "閲",
"闇": "暗",
// "阪": "阪 坂",
// "陞": "升 陞",
"陞": "升",
"隉": "陧",
"雋": "隽",
"雞": "鷄",
"霑": "沾",
"霢": "霡",
"靜": "静",
"靦": "腼",
"鞀": "鼗",
"鞝": "緔",
"韁": "繮",
"韝": "鞲",
"韻": "韵",
"頹": "頽",
"顏": "顔",
"飱": "飧",
"餈": "糍",
"餚": "肴",
"餬": "糊",
"餱": "糇",
"餵": "喂",
"騌": "鬃",
"鬨": "哄",
"鯗": "鮝",
"鯰": "鮎",
"鰮": "鰛",
"鱷": "鰐",
"鳧": "鳬",
"鵰": "雕",
"鶿": "鷀",
"鷈": "鷉",
"鷴": "鷳",
"鷿": "鸊",
"鹼": "碱",
"麪": "麵",
"麫": "麵",
"麬": "麩",
// "麴": "麯 麴",
"麴": "麯",
"麼": "麽",
"黃": "黄",
"鼴": "鼹",
"齎": "賫",
"齧": "嚙",
"齶": "腭",
"𡞵": "㛟",
"𡢃": "嫻",
"𡻕": "歲",
"𣈶": "暅",
"𥕦": "磙",
"𨎊": "𨍽",
]

}

