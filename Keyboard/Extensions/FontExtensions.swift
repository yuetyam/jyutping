import SwiftUI
import CommonExtensions
import CoreIME

extension Font {
        static let candidate: Font = Font.system(size: 20)
        static let romanization: Font = Font.system(size: 12)
        static let tone: Font = Font.system(size: 10)

        static let letterInputKeyCompact: Font = Font.system(size: 24)
        static let dualLettersInputKeyCompact: Font = Font.system(size: 17)
        static let keyFooter: Font = Font.system(size: 9)
}

extension String {

        private static let CNAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key(kCTLanguageAttributeName as String): "zh-Hans-CN"]
        private static let HKAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key(kCTLanguageAttributeName as String): "zh-Hant-HK"]
        private static let MOAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key(kCTLanguageAttributeName as String): "zh-Hant-MO"]
        private static let TWAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key(kCTLanguageAttributeName as String): "zh-Hant-TW"]

        private func attributedCN() -> AttributedString {
                AttributedString(self, attributes: AttributeContainer(Self.CNAttribute))
        }
        private func attributedHK() -> AttributedString {
                AttributedString(self, attributes: AttributeContainer(Self.HKAttribute))
        }
        private func attributedMO() -> AttributedString {
                AttributedString(self, attributes: AttributeContainer(Self.MOAttribute))
        }
        private func attributedTW() -> AttributedString {
                AttributedString(self, attributes: AttributeContainer(Self.TWAttribute))
        }

        func attributed(for characterStandard: CharacterStandard) -> AttributedString {
                switch characterStandard {
                case .traditional:
                        return CJKVStandard.isTCPreferred ? attributedHK() : AttributedString(self)
                case .hongkong:
                        return CJKVStandard.isHCPreferred ? AttributedString(self) : attributedHK()
                case .taiwan:
                        return AttributedString(self)
                case .simplified:
                        let isAnyNonSCStandardPreferred: Bool = CJKVStandard.isTCPreferred || CJKVStandard.isHCPreferred
                        return isAnyNonSCStandardPreferred ? attributedCN() : AttributedString(self)
                }
        }
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
