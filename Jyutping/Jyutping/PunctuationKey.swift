struct PunctuationKey: Hashable {

        let keyText: String
        let shiftingKeyText: String
        let instantSymbol: String?
        let instantShiftingSymbol: String?
        let symbols: [PunctuationSymbol]
        let shiftingSymbols: [PunctuationSymbol]

        static let comma: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("《"),
                        PunctuationSymbol("〈"),
                        PunctuationSymbol("«"),
                        PunctuationSymbol("‹"),
                        PunctuationSymbol("<", comment: "半形", secondaryComment: "U+003C"),
                        PunctuationSymbol("＜", comment: "全形", secondaryComment: "U+FF1C")
                ]
                return PunctuationKey(keyText: ",", shiftingKeyText: "<", instantSymbol: "，", instantShiftingSymbol: nil, symbols: [.init("，")], shiftingSymbols: shiftingSymbols)
        }()
        static let period: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("》"),
                        PunctuationSymbol("〉"),
                        PunctuationSymbol("»"),
                        PunctuationSymbol("›"),
                        PunctuationSymbol(">", comment: "半形", secondaryComment: "U+003E"),
                        PunctuationSymbol("＞", comment: "全形", secondaryComment: "U+FF1E"),
                        PunctuationSymbol("．", comment: "全形英文句號", secondaryComment: "U+FF0E"),
                        PunctuationSymbol("｡", comment: "半形句號", secondaryComment: "U+FF61")
                ]
                return PunctuationKey(keyText: ".", shiftingKeyText: ">", instantSymbol: "。", instantShiftingSymbol: nil, symbols: [.init("。")], shiftingSymbols: shiftingSymbols)
        }()
        static let slash: PunctuationKey = {
                let symbols: [PunctuationSymbol] = [
                        PunctuationSymbol("/", comment: "半形"),
                        PunctuationSymbol("／", comment: "全形"),
                        PunctuationSymbol("÷"),
                        PunctuationSymbol(String.fullWidthSpace, comment: "全形空格", secondaryComment: "U+3000")
                ]
                return PunctuationKey(keyText: "/", shiftingKeyText: "?", instantSymbol: nil, instantShiftingSymbol: "？", symbols: symbols, shiftingSymbols: [.init("？")])
        }()
        static let semicolon = PunctuationKey(keyText: ";", shiftingKeyText: ":", instantSymbol: "；", instantShiftingSymbol: "：", symbols: [.init("；")], shiftingSymbols: [.init("：")])
        static let bracketLeft: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("『"),
                        PunctuationSymbol("【"),
                        PunctuationSymbol("〖"),
                        PunctuationSymbol("〔"),
                        PunctuationSymbol("﹂", comment: "縱書"),
                        PunctuationSymbol("﹄", comment: "縱書"),
                        PunctuationSymbol("［", comment: "全形"),
                        PunctuationSymbol("[", comment: "半形"),
                        PunctuationSymbol("｛", comment: "全形"),
                        PunctuationSymbol("{", comment: "半形")
                ]
                return PunctuationKey(keyText: "[", shiftingKeyText: "{", instantSymbol: "「", instantShiftingSymbol: nil, symbols: [.init("「")], shiftingSymbols: shiftingSymbols)
        }()
        static let bracketRight: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("』"),
                        PunctuationSymbol("】"),
                        PunctuationSymbol("〗"),
                        PunctuationSymbol("〕"),
                        PunctuationSymbol("﹁", comment: "縱書"),
                        PunctuationSymbol("﹃", comment: "縱書"),
                        PunctuationSymbol("］", comment: "全形"),
                        PunctuationSymbol("]", comment: "半形"),
                        PunctuationSymbol("｝", comment: "全形"),
                        PunctuationSymbol("}", comment: "半形")
                ]
                return PunctuationKey(keyText: "]", shiftingKeyText: "}", instantSymbol: "」", instantShiftingSymbol: nil, symbols: [.init("」")], shiftingSymbols: shiftingSymbols)
        }()
        static let backSlash: PunctuationKey = {
                let shiftingSymbols: [PunctuationSymbol] = [
                        PunctuationSymbol("|", comment: "半形"),
                        PunctuationSymbol("｜", comment: "全形"),
                        PunctuationSymbol("\\", comment: "半形"),
                        PunctuationSymbol("＼", comment: "全形"),
                        PunctuationSymbol("•", comment: "Bullet", secondaryComment: "U+2022"),
                        PunctuationSymbol("·", comment: "陸標間隔號", secondaryComment: "Middle Dot, U+00B7"),
                        PunctuationSymbol("‧", comment: "港臺間隔號", secondaryComment: "U+2027"),
                        PunctuationSymbol("・", comment: "全形中點", secondaryComment: "U+30FB")
                ]
                return PunctuationKey(keyText: "\\", shiftingKeyText: "|", instantSymbol: "、", instantShiftingSymbol: nil, symbols: [.init("、")], shiftingSymbols: shiftingSymbols)
        }()
}


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

