import SwiftUI
import CommonExtensions

enum SpaceKeyForm: Int, CaseIterable {

        case english
        case fallback

        case lowercased
        case lowercasedMutilated
        case uppercased
        case uppercasedMutilated
        case capsLocked
        case capsLockedMutilated

        case confirm
        case confirmMutilated
        case select
        case selectMutilated
}

extension SpaceKeyForm {

        private static let formTexts: [SpaceKeyForm : String] = [
                .english            : "space",
                .fallback           : "空格",
                .lowercased         : "粵拼",
                .lowercasedMutilated: "粤拼",
                .uppercased         : "全寬空格",
                .uppercasedMutilated: "全宽空格",
                .capsLocked         : "大寫鎖定",
                .capsLockedMutilated: "大写锁定",
                .confirm            : "確認",
                .confirmMutilated   : "确认",
                .select             : "選定",
                .selectMutilated    : "选定",
        ]

        var text: String {
                Self.formTexts[self] ?? PresetConstant.spaceKeyFallbackText
        }

        var attributedText: AttributedString {
                let language: LanguageAttribute = {
                        switch self {
                        case .english:
                                return .enUS
                        case .fallback, .lowercased, .uppercased, .capsLocked, .confirm, .select:
                                return .jaJP
                        case .lowercasedMutilated, .uppercasedMutilated, .capsLockedMutilated, .confirmMutilated, .selectMutilated:
                                return .zhHansCN
                        }
                }()
                return text.languageAttributed(for: language)
        }
}
