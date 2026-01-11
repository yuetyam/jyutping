import Foundation
import CommonExtensions
import CoreIME

struct IndicatorTexts: Hashable, Identifiable {

        let short: String
        let long: String
        let isFlash: Bool
        let identifier: Int
        var id: Int {
                return identifier
        }

        private init(short: String, long: String? = nil, index: Int? = nil, isFlash: Bool = true, identifier: Int? = nil) {
                self.short = short
                self.long = if let long {
                        long
                } else if let index, let text = PresetConstant.optionsViewTexts[index] {
                        text
                } else {
                        "?"
                }
                self.isFlash = isFlash
                self.identifier = identifier ?? index ?? Int.random(in: 1000..<10000)
        }

        static func == (lhs: IndicatorTexts, rhs: IndicatorTexts) -> Bool {
                return lhs.identifier == rhs.identifier
        }
        func hash(into hasher: inout Hasher) {
                hasher.combine(identifier)
        }

        static let traditionalCharacterStandard = IndicatorTexts(short: "漢", index: 0)
        static let hongkongCharacterStandard = IndicatorTexts(short: "港", index: 1)
        static let taiwanCharacterStandard = IndicatorTexts(short: "臺", index: 2)
        static let simplifiedCharacterStandard = IndicatorTexts(short: "简", index: 3)
        static let halfWidthCharacterForm = IndicatorTexts(short: "半", index: 4)
        static let fullWidthCharacterForm = IndicatorTexts(short: "全", index: 5)
        static let punctuationCantoneseForm = IndicatorTexts(short: "。", index: 6)
        static let punctuationEnglishForm = IndicatorTexts(short: ".", index: 7)
        static let cantoneseMode = IndicatorTexts(short: "粵", long: "粵拼模式", identifier: 8)
        static let abcMode = IndicatorTexts(short: "A", long: "ABC Mode", identifier: 9)
        static let mutilatedCantoneseMode = IndicatorTexts(short: "粤", long: "粤拼模式・简", identifier: 10)

        static func matchTexts(for index: Int, isMutilated: Bool) -> IndicatorTexts? {
                switch index {
                case 0: traditionalCharacterStandard
                case 1: hongkongCharacterStandard
                case 2: taiwanCharacterStandard
                case 3: simplifiedCharacterStandard
                case 4: halfWidthCharacterForm
                case 5: fullWidthCharacterForm
                case 6: punctuationCantoneseForm
                case 7: punctuationEnglishForm
                case 8: isMutilated ? mutilatedCantoneseMode : cantoneseMode
                case 9: abcMode
                default: nil
                }
        }

        static func cangjieReverseLookup(for variant: CangjieVariant) -> IndicatorTexts {
                switch variant {
                case .cangjie5: cangjie5ReverseLookup
                case .cangjie3: cangjie3ReverseLookup
                case .quick5: quick5ReverseLookup
                case .quick3: quick3ReverseLookup
                }
        }
        static let cangjie5ReverseLookup = IndicatorTexts(short: "倉", long: "倉頡五代反查粵拼", isFlash: false, identifier: 111)
        static let cangjie3ReverseLookup = IndicatorTexts(short: "倉", long: "倉頡三代反查粵拼", isFlash: false, identifier: 112)
        static let quick5ReverseLookup = IndicatorTexts(short: "速", long: "速成五代反查粵拼", isFlash: false, identifier: 121)
        static let quick3ReverseLookup = IndicatorTexts(short: "速", long: "速成三代反查粵拼", isFlash: false, identifier: 122)

        static let pinyinReverseLookup = IndicatorTexts(short: "普", long: "普拼反查粵拼", isFlash: false, identifier: 201)
        static let strokeReverseLookup = IndicatorTexts(short: "筆", long: "筆畫反查粵拼", isFlash: false, identifier: 202)
        static let structureReverseLookup = IndicatorTexts(short: "拆", long: "兩分反查粵拼", isFlash: false, identifier: 203)
}
