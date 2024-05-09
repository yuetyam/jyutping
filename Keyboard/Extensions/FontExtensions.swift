import SwiftUI
import CommonExtensions
import CoreIME

extension Font {
        private(set) static var candidate: Font = candidateFont(size: 20)
        static func updateCandidateFont(characterStandard: CharacterStandard? = nil) {
                candidate = candidateFont(size: 20, characterStandard: characterStandard)
        }
        private static func candidateFont(size: CGFloat, characterStandard: CharacterStandard? = nil) -> Font {
                let standard: CharacterStandard = characterStandard ?? Options.characterStandard
                switch standard {
                case .traditional:
                        return CJKVStandard.isTCPreferred ? Font.custom(Constant.PingFangHK, fixedSize: size) : Font.system(size: size)
                case .hongkong:
                        return CJKVStandard.isHCPreferred ? Font.system(size: size) : Font.custom(Constant.PingFangHK, fixedSize: size)
                case .taiwan:
                        return Font.system(size: size)
                case .simplified:
                        let isAnyNonSCStandardPreferred: Bool = CJKVStandard.isTCPreferred || CJKVStandard.isHCPreferred
                        return isAnyNonSCStandardPreferred ? Font.custom(Constant.PingFangSC, fixedSize: size) : Font.system(size: size)
                }
        }

        static let romanization: Font = Font.system(size: 12)
        static let tone: Font = Font.system(size: 10)

        static let letterInputKeyCompact: Font = Font.system(size: 24)
        static let dualLettersInputKeyCompact: Font = Font.system(size: 17)
        static let keyFooter: Font = Font.system(size: 9)
}

private enum CJKVStandard: Int {
        case HC
        case TC
        case SC
        case JP
        static let preferredStandards: [CJKVStandard] = {
                let languages = Locale.preferredLanguages
                let standards = languages.compactMap({ language -> CJKVStandard? in
                        switch language {
                        case "zh-Hant-HK", "zh-Hant-MO", "zh-HK":
                                return .HC
                        case "zh-Hant-TW", "zh-TW":
                                return .TC
                        case "zh-Hans-CN", "zh-CN":
                                return .SC
                        case let code where code.hasPrefix("zh-Hant"):
                                return .TC
                        case let code where code.hasPrefix("zh-Hans"):
                                return .SC
                        case let code where code.hasPrefix("ja"):
                                return .JP
                        default:
                                return nil
                        }
                })
                return standards.uniqued()
        }()
        static let isHCPreferred: Bool = {
                guard let HCIndex = preferredStandards.firstIndex(of: .HC) else { return false }
                let TCIndex = preferredStandards.firstIndex(of: .TC) ?? 1000
                let SCIndex = preferredStandards.firstIndex(of: .SC) ?? 1000
                return min(HCIndex, TCIndex, SCIndex) == HCIndex
        }()
        static let isTCPreferred: Bool = {
                let HCIndex = preferredStandards.firstIndex(of: .HC) ?? 1000
                let TCIndex = preferredStandards.firstIndex(of: .TC) ?? 1000
                let SCIndex = preferredStandards.firstIndex(of: .SC) ?? 1000
                return min(HCIndex, TCIndex, SCIndex) == TCIndex
        }()
}
