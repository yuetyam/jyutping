import SwiftUI
import CommonExtensions
import CoreIME

/// Shared system fonts with fixed point sizes for keyboard labels, candidates, and emoji.
extension Font {

        /// Candidate text in the candidate bar and expanded candidate board of compact keyboards.
        static let candidate: Font = Font.system(size: 20)

        /// Larger candidate text in the candidate bar and expanded candidate board of iPad keyboards.
        static let iPadCandidate: Font = Font.system(size: 22)

        /// Syllable letters in Jyutping candidate annotations, excluding tone digits.
        static let romanization: Font = Font.system(size: 12)

        /// Tone digits in Jyutping candidate annotations; baseline offsets are applied separately.
        static let tone: Font = Font.system(size: 10)

        /// Primary input-key labels on compact keyboards, including letters, numbers, and symbols.
        static let compactKeyLabel: Font = Font.system(size: 24)

        /// Smaller input-key labels for multiple characters or visually dense glyphs, such as strokes.
        static let adjustedKeyLabel: Font = Font.system(size: 22)

        /// Compact input-key labels for multiple letters sharing a single key.
        static let tenseKeyLabel: Font = Font.system(size: 18)

        /// Emoji glyphs in the emoji board.
        static let emoji: Font = Font.system(size: 34)

        /// Action-key icons on compact keyboards, such as shift, backspace, and globe.
        static let symbol: Font = Font.system(size: 19)

        /// Text labels on keys such as space, return, and keyboard-layout switches.
        static let staticBody: Font = Font.system(size: 17)

        /// Small secondary key labels, including alternate inputs and editing-panel captions.
        static let labelCaption: Font = Font.system(size: 11)

        /// Larger alternate-input captions used by special keyboard layouts.
        static let labelLargerCaption: Font = Font.system(size: 14)
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
                        guard CJKVStandard.isNonCJKVPreferred.negative else {
                                return CJKVStandard.isSCPreferred ? attributedCNHans() : attributedHKHant()
                        }
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
                        return attributedJA()
                }
        }
        func attributed(for characterStandard: CharacterStandard) -> AttributedString {
                switch characterStandard {
                case .preset, .custom, .inherited, .etymology, .opencc:
                        guard CJKVStandard.isNonCJKVPreferred.negative else {
                                return CJKVStandard.isSCPreferred ? attributedCNHans() : attributedHKHant()
                        }
                        if CJKVStandard.isHCPreferred || CJKVStandard.isSCPreferred || (CJKVStandard.isJPPreferred && CJKVStandard.isTCPreferred.negative) {
                                return AttributedString(self)
                        } else {
                                return attributedHKHant()
                        }
                case .hongkong:
                        guard CJKVStandard.isNonCJKVPreferred.negative else {
                                return attributedHKHant()
                        }
                        if CJKVStandard.isHCPreferred || (CJKVStandard.isJPPreferred && CJKVStandard.isTCPreferred.negative) {
                                return AttributedString(self)
                        } else {
                                return attributedHKHant()
                        }
                case .taiwan:
                        return AttributedString(self)
                case .mutilated, .prcGeneral, .ancientBooksPublishing:
                        guard CJKVStandard.isNonCJKVPreferred.negative else {
                                return attributedCNHans()
                        }
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
        case nonCJKV
        static let preferredStandards: [CJKVStandard] = {
                let languages = Locale.preferredLanguages
                let standards = languages.map({ language -> CJKVStandard in
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
                                return .nonCJKV
                        }
                })
                return standards.distinct()
        }()
        static let isNonCJKVPreferred: Bool = {
                guard let nonCJKVIndex = preferredStandards.firstIndex(of: .nonCJKV) else { return false }
                guard let cjkvIndex = preferredStandards.firstIndex(where: { $0 != .nonCJKV }) else { return true }
                return nonCJKVIndex < cjkvIndex
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
