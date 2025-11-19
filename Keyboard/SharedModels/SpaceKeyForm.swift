import SwiftUI

enum SpaceKeyForm: Int {

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

        var text: String {
                switch self {
                case .english:
                        return "space"
                case .fallback:
                        return "空格"
                case .lowercased:
                        return "粵拼"
                case .lowercasedMutilated:
                        return "粤拼"
                case .uppercased:
                        return "全寬空格"
                case .uppercasedMutilated:
                        return "全宽空格"
                case .capsLocked:
                        return "大寫鎖定"
                case .capsLockedMutilated:
                        return "大写锁定"
                case .confirm:
                        return "確認"
                case .confirmMutilated:
                        return "确认"
                case .select:
                        return "選定"
                case .selectMutilated:
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
                        case .lowercasedMutilated, .uppercasedMutilated, .capsLockedMutilated, .confirmMutilated, .selectMutilated:
                                return .zhHansCN
                        }
                }()
                return text.languageAttributed(for: language)
        }
}
