import SwiftUI

enum SpaceKeyForm: Int {

        case english
        case fallback

        case lowercased
        case lowercasedSimplified
        case uppercased
        case uppercasedSimplified
        case capsLocked
        case capsLockedSimplified

        case confirm
        case confirmSimplified
        case select
        case selectSimplified

        var text: String {
                switch self {
                case .english:
                        return "space"
                case .fallback:
                        return "空格"
                case .lowercased:
                        return "粵拼"
                case .lowercasedSimplified:
                        return "粤拼·简化字"
                case .uppercased:
                        return "全寬空格"
                case .uppercasedSimplified:
                        return "全宽空格"
                case .capsLocked:
                        return "大寫鎖定"
                case .capsLockedSimplified:
                        return "大写锁定"
                case .confirm:
                        return "確認"
                case .confirmSimplified:
                        return "确认"
                case .select:
                        return "選定"
                case .selectSimplified:
                        return "选定"
                }
        }
        var attributedText: AttributedString {
                let language: LanguageAttribute = {
                        switch self {
                        case .english:
                                return .enUS
                        case .fallback:
                                return .unspecified
                        case .lowercased, .uppercased, .capsLocked, .confirm, .select:
                                return .zhHantHK
                        case .lowercasedSimplified, .uppercasedSimplified, .capsLockedSimplified, .confirmSimplified, .selectSimplified:
                                return .zhHansCN
                        }
                }()
                return text.languageAttributed(for: language)
        }
}
