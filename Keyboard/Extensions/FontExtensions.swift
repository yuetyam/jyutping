import SwiftUI
import CoreIME

extension Font {

        private static var isSystemFontPreferred: Bool {
                let languages = Locale.preferredLanguages
                let HCIndex = languages.firstIndex(of: "zh-Hant-HK") ?? languages.firstIndex(of: "zh-Hant-MO") ?? 1000
                let TCIndex = languages.firstIndex(where: { $0 != "zh-Hant-HK" && $0 != "zh-Hant-MO" && $0.hasPrefix("zh-Hant-") }) ?? 1000
                let SCIndex = languages.firstIndex(where: { $0.hasPrefix("zh-Hans-") }) ?? 1000
                return min(HCIndex, TCIndex, SCIndex) != TCIndex
        }

        private(set) static var candidate: Font = candidateFont(size: 20)
        static func updateCandidateFont(characterStandard: CharacterStandard? = nil) {
                candidate = candidateFont(size: 20, characterStandard: characterStandard)
        }
        private static func candidateFont(size: CGFloat, characterStandard: CharacterStandard? = nil) -> Font {
                let standard: CharacterStandard = characterStandard ?? Options.characterStandard
                switch standard {
                case .traditional:
                        return isSystemFontPreferred ? Font.system(size: size) : Font.custom(Constant.PingFangHK, fixedSize: size)
                case .hongkong:
                        return isSystemFontPreferred ? Font.system(size: size) : Font.custom(Constant.PingFangHK, fixedSize: size)
                case .taiwan:
                        return Font.system(size: size)
                case .simplified:
                        return Font.custom(Constant.PingFangSC, fixedSize: size)
                }
        }

        static let romanization: Font = Font.system(size: 12)
        static let tone: Font = Font.system(size: 10)

        static let letterInputKeyCompact: Font = Font.system(size: 24)
        static let dualLettersInputKeyCompact: Font = Font.system(size: 17)
        static let keyFooter: Font = Font.system(size: 9)
}
