import Foundation
import CommonExtensions
import CoreIME

struct PunctuationSymbol: Hashable {

        let symbol: String
        let comment: String?
        let secondaryComment: String?

        init(_ symbol: String, comment: String? = nil, secondaryComment: String? = nil) {
                self.symbol = symbol
                self.comment = comment
                self.secondaryComment = secondaryComment
        }
}

struct PunctuationKey: Hashable {
        let keyText: String
        let shiftingKeyText: String
        let instantSymbol: String?
        let instantShiftingSymbol: String?
        let symbols: [PunctuationSymbol]
        let shiftingSymbols: [PunctuationSymbol]
}

extension PunctuationKey {
        static let comma: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("《"),
                        PunctuationSymbol("〈"),
                        PunctuationSymbol("<", comment: "小於號"),
                        PunctuationSymbol("＜", comment: "全寬小於號"),
                        PunctuationSymbol(",", comment: "半寬逗號")
                ]
                return PunctuationKey(keyText: ",", shiftingKeyText: "<", instantSymbol: "，", instantShiftingSymbol: nil, symbols: [.init("，")], shiftingSymbols: shiftingSymbols)
        }()
        static let period: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("》"),
                        PunctuationSymbol("〉"),
                        PunctuationSymbol(">", comment: "大於號"),
                        PunctuationSymbol("＞", comment: "全寬大於號"),
                        PunctuationSymbol("｡", comment: "半寬句號"),
                        PunctuationSymbol(".", comment: "英文句號"),
                        PunctuationSymbol("．", comment: "全寬英文句號")
                ]
                return PunctuationKey(keyText: ".", shiftingKeyText: ">", instantSymbol: "。", instantShiftingSymbol: nil, symbols: [.init("。")], shiftingSymbols: shiftingSymbols)
        }()
        static let slash: PunctuationKey = {
                let symbols: [PunctuationSymbol] = [
                        PunctuationSymbol("/"),
                        PunctuationSymbol("／", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("÷"),
                        PunctuationSymbol("≠"),
                        PunctuationSymbol("?", comment: PresetConstant.halfWidth),
                        PunctuationSymbol("!", comment: PresetConstant.halfWidth),
                        PunctuationSymbol(String.fullWidthSpace, comment: "全寬空格")
                ]
                return PunctuationKey(keyText: "/", shiftingKeyText: "?", instantSymbol: nil, instantShiftingSymbol: "？", symbols: symbols, shiftingSymbols: [.init("？")])
        }()
        static let semicolon = PunctuationKey(keyText: ";", shiftingKeyText: ":", instantSymbol: "；", instantShiftingSymbol: "：", symbols: [.init("；")], shiftingSymbols: [.init("：")])
        static let quote: PunctuationKey = {
                let symbols: [PunctuationSymbol] = [
                        PunctuationSymbol("'", comment: "U+0027"),
                        PunctuationSymbol("＇", comment: PresetConstant.fullWidth, secondaryComment: "U+FF07"),
                        PunctuationSymbol("‘", comment: "左", secondaryComment: "U+2018"),
                        PunctuationSymbol("’", comment: "右", secondaryComment: "U+2019"),
                        PunctuationSymbol(";", comment: "半寬分號"),
                        // PunctuationSymbol("\u{2018}\u{FE01}", comment: "全寬左", secondaryComment: "U+2018 U+FE01"),
                        // PunctuationSymbol("\u{2019}\u{FE01}", comment: "全寬右", secondaryComment: "U+2019 U+FE01"),
                ]
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("\"", comment: "U+0022"),
                        PunctuationSymbol("＂", comment: PresetConstant.fullWidth, secondaryComment: "U+FF02"),
                        PunctuationSymbol("“", comment: "左", secondaryComment: "U+201C"),
                        PunctuationSymbol("”", comment: "右", secondaryComment: "U+201D"),
                        PunctuationSymbol(":", comment: "半寬冒號"),
                        // PunctuationSymbol("\u{201C}\u{FE01}", comment: "全寬左", secondaryComment: "U+201C U+FE01"),
                        // PunctuationSymbol("\u{201D}\u{FE01}", comment: "全寬右", secondaryComment: "U+201D U+FE01"),
                ]
                return PunctuationKey(keyText: "'", shiftingKeyText: "\"", instantSymbol: nil, instantShiftingSymbol: nil, symbols: symbols, shiftingSymbols: shiftingSymbols)
        }()
        static let bracketLeft: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("『"),
                        PunctuationSymbol("【"),
                        PunctuationSymbol("〖"),
                        PunctuationSymbol("〔"),
                        PunctuationSymbol("[", comment: PresetConstant.halfWidth),
                        PunctuationSymbol("［", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("{", comment: PresetConstant.halfWidth),
                        PunctuationSymbol("｛", comment: PresetConstant.fullWidth)
                ]
                return PunctuationKey(keyText: "[", shiftingKeyText: "{", instantSymbol: "「", instantShiftingSymbol: nil, symbols: [.init("「")], shiftingSymbols: shiftingSymbols)
        }()
        static let bracketRight: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("』"),
                        PunctuationSymbol("】"),
                        PunctuationSymbol("〗"),
                        PunctuationSymbol("〕"),
                        PunctuationSymbol("]", comment: PresetConstant.halfWidth),
                        PunctuationSymbol("］", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("}", comment: PresetConstant.halfWidth),
                        PunctuationSymbol("｝", comment: PresetConstant.fullWidth)
                ]
                return PunctuationKey(keyText: "]", shiftingKeyText: "}", instantSymbol: "」", instantShiftingSymbol: nil, symbols: [.init("」")], shiftingSymbols: shiftingSymbols)
        }()
        static let backSlash: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("|"),
                        PunctuationSymbol("｜", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("\\"),
                        PunctuationSymbol("＼", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("､", comment: "半寬頓號")
                ]
                return PunctuationKey(keyText: "\\", shiftingKeyText: "|", instantSymbol: "、", instantShiftingSymbol: nil, symbols: [.init("、")], shiftingSymbols: shiftingSymbols)
        }()
        static let grave: PunctuationKey = {
                let symbols: [PunctuationSymbol] = [
                        PunctuationSymbol("`", comment: "重音符", secondaryComment: "U+0060"),
                        PunctuationSymbol("｀", comment: "全寬重音符", secondaryComment: "U+FF40"),
                        PunctuationSymbol("·", comment: "間隔號", secondaryComment: "U+00B7"),
                        PunctuationSymbol("•", comment: "項目符號", secondaryComment: "U+2022"),
                        PunctuationSymbol("‧", comment: "連字點", secondaryComment: "U+2027"),
                        PunctuationSymbol("･", comment: "半寬中點", secondaryComment: "U+FF65"),
                        PunctuationSymbol("・", comment: "全寬中點", secondaryComment: "U+30FB"),
                        PunctuationSymbol("◉", comment: "魚眼", secondaryComment: "U+25C9"),
                ]
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("~"),
                        PunctuationSymbol("～", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("≈")
                ]
                return PunctuationKey(keyText: "`", shiftingKeyText: "~", instantSymbol: nil, instantShiftingSymbol: nil, symbols: symbols, shiftingSymbols: shiftingSymbols)
        }()
        static let minus = PunctuationKey(keyText: "-", shiftingKeyText: "_", instantSymbol: "-", instantShiftingSymbol: "——", symbols: [.init("-")], shiftingSymbols: [.init("——")])
        static let equal = PunctuationKey(keyText: "=", shiftingKeyText: "+", instantSymbol: "=", instantShiftingSymbol: "+", symbols: [.init("=")], shiftingSymbols: [.init("+")])
}

extension PunctuationKey {
        static let number1One = PunctuationKey(keyText: "1", shiftingKeyText: "!", instantSymbol: "1", instantShiftingSymbol: "！", symbols: [.init("1")], shiftingSymbols: [.init("！")])
        static let number2Two: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("@"),
                        PunctuationSymbol("＠", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("©"),
                        PunctuationSymbol("®")
                ]
                return PunctuationKey(keyText: "2", shiftingKeyText: "@", instantSymbol: "2", instantShiftingSymbol: nil, symbols: [.init("2")], shiftingSymbols: shiftingSymbols)
        }()
        static let number3Three: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("#"),
                        PunctuationSymbol("＃", comment: PresetConstant.fullWidth)
                ]
                return PunctuationKey(keyText: "3", shiftingKeyText: "#", instantSymbol: "3", instantShiftingSymbol: nil, symbols: [.init("3")], shiftingSymbols: shiftingSymbols)
        }()
        static let number4Four: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("$"),
                        PunctuationSymbol("＄", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("€"),
                        PunctuationSymbol("£"),
                        PunctuationSymbol("¥"),
                        PunctuationSymbol("￥", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("₩"),
                        PunctuationSymbol("₽"),
                        PunctuationSymbol("¢")
                ]
                return PunctuationKey(keyText: "4", shiftingKeyText: "$", instantSymbol: "4", instantShiftingSymbol: nil, symbols: [.init("4")], shiftingSymbols: shiftingSymbols)
        }()
        static let number5Five: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("%"),
                        PunctuationSymbol("％", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("‰"),
                        PunctuationSymbol("‱"),
                        PunctuationSymbol("°"),
                        PunctuationSymbol("℃"),
                        PunctuationSymbol("℉"),
                        PunctuationSymbol("∞")
                ]
                return PunctuationKey(keyText: "5", shiftingKeyText: "%", instantSymbol: "5", instantShiftingSymbol: nil, symbols: [.init("5")], shiftingSymbols: shiftingSymbols)
        }()
        static let number6Six: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("^"),
                        PunctuationSymbol("＾", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("……"),
                        PunctuationSymbol("…")
                ]
                return PunctuationKey(keyText: "6", shiftingKeyText: "^", instantSymbol: "6", instantShiftingSymbol: nil, symbols: [.init("6")], shiftingSymbols: shiftingSymbols)
        }()
        static let number7Seven: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("&"),
                        PunctuationSymbol("＆", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("§")
                ]
                return PunctuationKey(keyText: "7", shiftingKeyText: "&", instantSymbol: "7", instantShiftingSymbol: nil, symbols: [.init("7")], shiftingSymbols: shiftingSymbols)
        }()
        static let number8Eight: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("*"),
                        PunctuationSymbol("＊", comment: PresetConstant.fullWidth),
                        PunctuationSymbol("×", comment: "乘號"),
                        PunctuationSymbol("·", comment: "間隔號"),
                        PunctuationSymbol("•", comment: "項目符號"),
                        PunctuationSymbol("※", comment: "參攷號"),
                        PunctuationSymbol("◉", comment: "魚眼"),
                ]
                return PunctuationKey(keyText: "8", shiftingKeyText: "*", instantSymbol: "8", instantShiftingSymbol: nil, symbols: [.init("8")], shiftingSymbols: shiftingSymbols)
        }()
        static let number9Nine = PunctuationKey(keyText: "9", shiftingKeyText: "(", instantSymbol: "9", instantShiftingSymbol: "（", symbols: [.init("9")], shiftingSymbols: [.init("（")])
        static let number0Zero = PunctuationKey(keyText: "0", shiftingKeyText: ")", instantSymbol: "0", instantShiftingSymbol: "）", symbols: [.init("0")], shiftingSymbols: [.init("）")])
}

extension PunctuationKey {

        /// Shifting number key Cantonese PunctuationForm
        static func numberKeyPunctuation(of number: Int) -> PunctuationKey? {
                switch number {
                case 2: PunctuationKey.number2Two
                case 3: PunctuationKey.number3Three
                case 4: PunctuationKey.number4Four
                case 5: PunctuationKey.number5Five
                case 6: PunctuationKey.number6Six
                case 7: PunctuationKey.number7Seven
                case 8: PunctuationKey.number8Eight
                default: nil
                }
        }

        /// Shifting number key symbol in English PunctuationForm
        static func numberKeyShiftingSymbol(of number: Int) -> String? {
                switch number {
                case 0: ")"
                case 1: "!"
                case 2: "@"
                case 3: "#"
                case 4: "$"
                case 5: "%"
                case 6: "^"
                case 7: "&"
                case 8: "*"
                case 9: "("
                default: nil
                }
        }

        /// Shifting number key symbol in Cantonese PunctuationForm
        static func numberKeyShiftingCantoneseSymbol(of number: Int) -> String? {
                switch number {
                case 0: "）"
                case 1: "！"
                case 2: "@"
                case 3: "#"
                case 4: "$"
                case 5: "%"
                case 6: "……"
                case 7: "&"
                case 8: "*"
                case 9: "（"
                default: nil
                }
        }
}
