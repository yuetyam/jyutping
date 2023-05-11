import UIKit

extension Optional where Wrapped == UIReturnKeyType {
        func returnKeyText(isABC: Bool, isSimplified: Bool, isBuffering: Bool) -> String {
                guard !isBuffering else {
                        return isSimplified ? "确认" : "確認"
                }
                guard !isABC else {
                        guard let returnKeyType = self else { return "return" }
                        switch returnKeyType {
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
                        case .yahoo:
                                return "yahoo"
                        @unknown default:
                                return "return"
                        }
                }
                guard !isSimplified else {
                        guard let returnKeyType = self else { return "换行" }
                        switch returnKeyType {
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
                        case .yahoo:
                                return "雅虎"
                        @unknown default:
                                return "换行"
                        }
                }
                guard let returnKeyType = self else { return "換行" }
                switch returnKeyType {
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
                case .yahoo:
                        return "雅虎"
                @unknown default:
                        return "換行"
                }
        }
}
