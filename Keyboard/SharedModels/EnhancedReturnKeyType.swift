import SwiftUI
import CommonExtensions

enum ReturnKeyState: Int {

        case bufferingSimplified
        case bufferingTraditional
        case standbyABC
        case standbySimplified
        case standbyTraditional
        case unavailableABC
        case unavailableSimplified
        case unavailableTraditional

        var isAvailable: Bool {
                switch self {
                case .unavailableABC, .unavailableSimplified, .unavailableTraditional:
                        return false
                default:
                        return true
                }
        }

        static func state(isAvailable: Bool, isABC: Bool, isSimplified: Bool, isBuffering: Bool) -> ReturnKeyState {
                guard isBuffering.negative else {
                        return isSimplified ? .bufferingSimplified : .bufferingTraditional
                }
                guard isABC.negative else {
                        return isAvailable ? .standbyABC : .unavailableABC
                }
                guard isSimplified.negative else {
                        return isAvailable ? .standbySimplified : .unavailableSimplified
                }
                return isAvailable ? .standbyTraditional : .unavailableTraditional
        }
}

enum EnhancedReturnKeyType: Int {

        case `continue`
        case `default`
        case done
        case emergencyCall
        case go
        case google
        case join
        case next
        case route
        case search
        case send
        case unknown
        case unspecified
        case yahoo

        var isDefaultReturn: Bool {
                switch self {
                case .default, .unknown, .unspecified:
                        return true
                default:
                        return false
                }
        }
}

extension Optional where Wrapped == UIReturnKeyType {
        var enhancedReturnKeyType: EnhancedReturnKeyType {
                guard let type = self else { return .unspecified }
                switch type {
                case .continue:
                        return .continue
                case .default:
                        return .default
                case .done:
                        return .done
                case .emergencyCall:
                        return .emergencyCall
                case .go:
                        return .go
                case .google:
                        return .google
                case .join:
                        return .join
                case .next:
                        return .next
                case .route:
                        return .route
                case .search:
                        return .search
                case .send:
                        return .send
                case .yahoo:
                        return .yahoo
                @unknown default:
                        return .unknown
                }
        }
}

extension EnhancedReturnKeyType {
        func text(of state: ReturnKeyState) -> String {
                switch state {
                case .bufferingSimplified:
                        return "确认"
                case .bufferingTraditional:
                        return "確認"
                case .standbyABC, .unavailableABC:
                        switch self {
                        case .continue:
                                return "continue"
                        case .default:
                                return "return"
                        case .done:
                                return "done"
                        case .emergencyCall:
                                return "emergency"
                        case .go:
                                return "go"
                        case .google:
                                return "google"
                        case .join:
                                return "join"
                        case .next:
                                return "next"
                        case .route:
                                return "route"
                        case .search:
                                return "search"
                        case .send:
                                return "send"
                        case .unknown:
                                return "return"
                        case .unspecified:
                                return "return"
                        case .yahoo:
                                return "yahoo"
                        }
                case .standbySimplified, .unavailableSimplified:
                        switch self {
                        case .continue:
                                return "继续"
                        case .default:
                                return "换行"
                        case .done:
                                return "完成"
                        case .emergencyCall:
                                return "紧急"
                        case .go:
                                return "前往"
                        case .google:
                                return "谷歌"
                        case .join:
                                return "加入"
                        case .next:
                                return "下一个"
                        case .route:
                                return "路线"
                        case .search:
                                return "搜寻"
                        case .send:
                                return "传送"
                        case .unknown:
                                return "换行"
                        case .unspecified:
                                return "换行"
                        case .yahoo:
                                return "雅虎"
                        }
                case .standbyTraditional, .unavailableTraditional:
                        switch self {
                        case .continue:
                                return "繼續"
                        case .default:
                                return "換行"
                        case .done:
                                return "完成"
                        case .emergencyCall:
                                return "緊急"
                        case .go:
                                return "前往"
                        case .google:
                                return "谷歌"
                        case .join:
                                return "加入"
                        case .next:
                                return "下一個"
                        case .route:
                                return "路線"
                        case .search:
                                return "搜尋"
                        case .send:
                                return "傳送"
                        case .unknown:
                                return "換行"
                        case .unspecified:
                                return "換行"
                        case .yahoo:
                                return "雅虎"
                        }
                }
        }
        func attributedText(of state: ReturnKeyState) -> AttributedString {
                let language: LanguageAttribute = {
                        switch state {
                        case .standbyABC, .unavailableABC:
                                return .enUS
                        case .bufferingSimplified, .standbySimplified, .unavailableSimplified:
                                return .zhHansCN
                        case .bufferingTraditional, .standbyTraditional, .unavailableTraditional:
                                return .zhHantHK
                        }
                }()
                return text(of: state).languageAttributed(for: language)
        }
}
