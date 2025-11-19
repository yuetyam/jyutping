import SwiftUI
import CommonExtensions

enum ReturnKeyState: Int {

        case bufferingMutilated
        case bufferingTraditional
        case standbyABC
        case standbyMutilated
        case standbyTraditional
        case unavailableABC
        case unavailableMutilated
        case unavailableTraditional

        var isAvailable: Bool {
                switch self {
                case .unavailableABC, .unavailableMutilated, .unavailableTraditional:
                        return false
                default:
                        return true
                }
        }

        var isBuffering: Bool {
                switch self {
                case .bufferingMutilated, .bufferingTraditional:
                        return true
                default:
                        return false
                }
        }

        static func state(isAvailable: Bool, isABC: Bool, isMutilated: Bool, isBuffering: Bool) -> ReturnKeyState {
                guard isBuffering.negative else {
                        return isMutilated ? .bufferingMutilated : .bufferingTraditional
                }
                guard isABC.negative else {
                        return isAvailable ? .standbyABC : .unavailableABC
                }
                guard isMutilated.negative else {
                        return isAvailable ? .standbyMutilated : .unavailableMutilated
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

        func attributedText(of state: ReturnKeyState) -> AttributedString {
                let language: LanguageAttribute = {
                        switch state {
                        case .standbyABC, .unavailableABC:
                                return .enUS
                        case .bufferingMutilated, .standbyMutilated, .unavailableMutilated:
                                return .zhHansCN
                        case .bufferingTraditional, .standbyTraditional, .unavailableTraditional:
                                return .zhHantHK
                        }
                }()
                return text(of: state).languageAttributed(for: language)
        }
        func text(of state: ReturnKeyState) -> String {
                switch state {
                case .bufferingMutilated:
                        return Self.confirmMutilated
                case .bufferingTraditional:
                        return Self.confirm
                case .standbyABC, .unavailableABC:
                        return Self.abcMap[self] ?? Self.returnABC
                case .standbyMutilated, .unavailableMutilated:
                        return Self.mutilatedMap[self] ?? Self.returnMutilated
                case .standbyTraditional, .unavailableTraditional:
                        return Self.traditionalMap[self] ?? Self.returnTraditional
                }
        }

        private static let confirm          : String = "確認"
        private static let confirmMutilated : String = "确认"
        private static let returnABC        : String = "return"
        private static let returnTraditional: String = "換行"
        private static let returnMutilated  : String = "换行"

        private static let abcMap: [EnhancedReturnKeyType: String] = [
                .continue     : "continue",
                .default      : "return",
                .done         : "done",
                .emergencyCall: "emergency",
                .go           : "go",
                .google       : "google",
                .join         : "join",
                .next         : "next",
                .route        : "route",
                .search       : "search",
                .send         : "send",
                .unknown      : "return",
                .unspecified  : "return",
                .yahoo        : "yahoo"
        ]
        private static let mutilatedMap: [EnhancedReturnKeyType: String] = [
                .continue     : "继续",
                .default      : "换行",
                .done         : "完成",
                .emergencyCall: "紧急",
                .go           : "前往",
                .google       : "谷歌",
                .join         : "加入",
                .next         : "下一个",
                .route        : "路线",
                .search       : "搜寻",
                .send         : "传送",
                .unknown      : "换行",
                .unspecified  : "换行",
                .yahoo        : "雅虎"
        ]
        private static let traditionalMap: [EnhancedReturnKeyType: String] = [
                .continue     : "繼續",
                .default      : "換行",
                .done         : "完成",
                .emergencyCall: "緊急",
                .go           : "前往",
                .google       : "谷歌",
                .join         : "加入",
                .next         : "下一個",
                .route        : "路線",
                .search       : "搜尋",
                .send         : "傳送",
                .unknown      : "換行",
                .unspecified  : "換行",
                .yahoo        : "雅虎"
        ]
}
