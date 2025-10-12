import SwiftUI
import CommonExtensions
import CoreIME

extension Font {
        static let candidate: Font = Font.system(size: 20)
        static let iPadCandidate: Font = Font.system(size: 22)
        static let romanization: Font = Font.system(size: 12)
        static let tone: Font = Font.system(size: 10)

        static let letterCompact: Font = Font.system(size: 24)
        static let dualLettersCompact: Font = Font.system(size: 18)
        static let keyFootnote: Font = Font.system(size: 10)

        /// EmojiBoard emoji view
        static let emoji: Font = Font.system(size: 34)

        /// compact keyboard action keys
        static let symbol: Font = Font.system(size: 19)

        static let staticBody: Font = Font.system(size: 17)
        static let keyCaption: Font = Font.system(size: 11)
}

enum LanguageAttribute: Int {
        case unspecified
        case zhHantHK
        case zhHantTW
        case zhHansCN
        case enUS
        case jaJP
}

extension String {

        nonisolated(unsafe) private static let HKHantAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key(kCTLanguageAttributeName as String): "zh-Hant-HK"]
        nonisolated(unsafe) private static let TWHantAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key(kCTLanguageAttributeName as String): "zh-Hant-TW"]
        nonisolated(unsafe) private static let CNHansAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key(kCTLanguageAttributeName as String): "zh-Hans-CN"]
        nonisolated(unsafe) private static let ENAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key(kCTLanguageAttributeName as String): "en-US"]
        nonisolated(unsafe) private static let JAAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key(kCTLanguageAttributeName as String): "ja-JP"]

        private func attributedHKHant() -> AttributedString {
                AttributedString(self, attributes: AttributeContainer(Self.HKHantAttribute))
        }
        private func attributedTWHant() -> AttributedString {
                AttributedString(self, attributes: AttributeContainer(Self.TWHantAttribute))
        }
        private func attributedCNHans() -> AttributedString {
                AttributedString(self, attributes: AttributeContainer(Self.CNHansAttribute))
        }
        private func attributedEN() -> AttributedString {
                AttributedString(self, attributes: AttributeContainer(Self.ENAttribute))
        }
        private func attributedJA() -> AttributedString {
                AttributedString(self, attributes: AttributeContainer(Self.JAAttribute))
        }

        func languageAttributed(for language: LanguageAttribute) -> AttributedString {
                switch language {
                case .unspecified, .zhHantHK:
                        if CJKVStandard.isHCPreferred || CJKVStandard.isSCPreferred || (CJKVStandard.isJPPreferred && CJKVStandard.isTCPreferred.negative) {
                                return AttributedString(self)
                        } else {
                                return attributedHKHant()
                        }
                case .zhHantTW:
                        return AttributedString(self)
                case .zhHansCN:
                        return attributedCNHans()
                case .enUS:
                        return AttributedString(self)
                case .jaJP:
                        return AttributedString(self)
                }
        }
        func attributed(for characterStandard: CharacterStandard) -> AttributedString {
                switch characterStandard {
                case .traditional:
                        if CJKVStandard.isHCPreferred || CJKVStandard.isSCPreferred || (CJKVStandard.isJPPreferred && CJKVStandard.isTCPreferred.negative) {
                                return AttributedString(self)
                        } else {
                                return attributedHKHant()
                        }
                case .hongkong:
                        if CJKVStandard.isHCPreferred || (CJKVStandard.isJPPreferred && CJKVStandard.isTCPreferred.negative) {
                                return AttributedString(self)
                        } else {
                                return attributedHKHant()
                        }
                case .taiwan:
                        return AttributedString(self)
                case .simplified:
                        if CJKVStandard.isSCPreferred || (CJKVStandard.isJPPreferred && CJKVStandard.isTCPreferred.negative) {
                                return AttributedString(self)
                        } else {
                                return attributedCNHans()
                        }
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
                        case "zh-Hant-HK", "zh-HK", "yue-Hant-HK", "yue-Hant", "yue":
                                return .HC
                        case "zh-Hant-TW", "zh-TW":
                                return .TC
                        case "zh-Hans-CN", "zh-CN":
                                return .SC
                        case let code where code.hasPrefix("zh-Hant"):
                                return .TC
                        case let code where code.hasPrefix("zh-Hans"):
                                return .SC
                        case let code where code.hasPrefix("yue-Hant"):
                                return .HC
                        case let code where code.hasPrefix("yue-Hans"):
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
                let JPIndex = preferredStandards.firstIndex(of: .JP) ?? 1000
                return min(HCIndex, TCIndex, SCIndex, JPIndex) == HCIndex
        }()
        static let isTCPreferred: Bool = {
                let HCIndex = preferredStandards.firstIndex(of: .HC) ?? 1000
                let TCIndex = preferredStandards.firstIndex(of: .TC) ?? 1000
                let SCIndex = preferredStandards.firstIndex(of: .SC) ?? 1000
                return min(HCIndex, TCIndex, SCIndex) == TCIndex
        }()
        static let isSCPreferred: Bool = {
                guard let SCIndex = preferredStandards.firstIndex(of: .SC) else { return false }
                let HCIndex = preferredStandards.firstIndex(of: .HC) ?? 1000
                let TCIndex = preferredStandards.firstIndex(of: .TC) ?? 1000
                let JPIndex = preferredStandards.firstIndex(of: .JP) ?? 1000
                return min(SCIndex, HCIndex, TCIndex, JPIndex) == SCIndex
        }()
        static let isJPPreferred: Bool = {
                guard let JPIndex = preferredStandards.firstIndex(of: .JP) else { return false }
                let HCIndex = preferredStandards.firstIndex(of: .HC) ?? 1000
                let TCIndex = preferredStandards.firstIndex(of: .TC) ?? 1000
                let SCIndex = preferredStandards.firstIndex(of: .SC) ?? 1000
                return min(JPIndex, HCIndex, TCIndex, SCIndex) == JPIndex
        }()
}
