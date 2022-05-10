import SwiftUI

extension Font {

        static let fixedWidth: Font = {
                if #available(iOS 15.0, macOS 12.0, *) {
                        return Font.body.monospaced()
                } else {
                        return Font.system(.body, design: .monospaced)
                }
        }()

        static let master: Font = {
                let size: CGFloat = {
                        #if os(iOS)
                        return 17
                        #else
                        return 13
                        #endif
                }()
                return Font.custom(primaryFontName, size: size, relativeTo: .body)
        }()

        static let masterHeadline: Font = {
                #if os(iOS)
                return Font.custom(primaryFontName, size: 17, relativeTo: .body).weight(.medium)
                #else
                return Font.custom(primaryFontName, size: 15, relativeTo: .title3)
                #endif
        }()

        private static let primaryFontName: String = {
                let preferredList: [String] = ["ChiuKong Gothic CL", "Source Han Sans K", "Noto Sans CJK KR"]
                let fontName: String = {
                        for name in preferredList {
                                #if os(iOS)
                                if let font = UIFont(name: name, size: 17) {
                                        return name
                                }
                                #else
                                if let font = NSFont(name: name, size: 13) {
                                        return name
                                }
                                #endif
                        }
                        return "PingFang HK"
                }()
                return fontName
        }()
}

