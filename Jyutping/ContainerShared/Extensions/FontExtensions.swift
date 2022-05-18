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
                #if os(iOS)
                return Font.body
                #else
                return generateFont(size: 13, style: .body)
                #endif
        }()
        static let masterHeadline: Font = {
                #if os(iOS)
                return Font.body.weight(.medium)
                #else
                return generateFont(size: 15, style: .title3)
                #endif
        }()

        #if os(macOS)
        private static func generateFont(size: CGFloat, style: Font.TextStyle) -> Font {
                let primaryFontName: String = {
                        let preferredList: [String] = ["ChiuKong Gothic CL", "Source Han Sans K", "Noto Sans CJK KR", "Sarasa Gothic CL"]
                        for name in preferredList {
                                if let _ = NSFont(name: name, size: size) {
                                        return name
                                }
                        }
                        return "PingFang HK"
                }()
                let fallbackFontNames: [String] = {
                        let expected: [String] = ["I.MingCP", "I.Ming", "HanaMinB"]
                        let results: [String?] = expected.map { name -> String? in
                                if let _ = NSFont(name: name, size: size) {
                                        return name
                                } else {
                                        return nil
                                }
                        }
                        let found: [String] = results.compactMap({ $0 })
                        return found
                }()
                if fallbackFontNames.isEmpty {
                        return Font.custom(primaryFontName, size: size, relativeTo: style)
                } else {
                        return pairFonts(primary: primaryFontName, fallbacks: fallbackFontNames, size: size)
                }
        }
        #endif

        #if os(macOS)
        private static func pairFonts(primary name: String, fallbacks: [String], size: CGFloat) -> Font {
                let originalFont: NSFont = NSFont(name: name, size: size) ?? .systemFont(ofSize: size)
                let originalDescriptor: NSFontDescriptor = originalFont.fontDescriptor
                let fallbackDescriptors: [NSFontDescriptor] = fallbacks.map { fontName -> NSFontDescriptor in
                        return originalDescriptor.addingAttributes([.name: fontName])
                }
                let pairedDescriptor: NSFontDescriptor = originalDescriptor.addingAttributes([.cascadeList : fallbackDescriptors])
                let pairedFont: NSFont = NSFont(descriptor: pairedDescriptor, size: size) ?? .systemFont(ofSize: size)
                return Font(pairedFont)
        }
        #endif
}
