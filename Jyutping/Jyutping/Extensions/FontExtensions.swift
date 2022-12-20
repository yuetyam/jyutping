import SwiftUI

extension Font {

        static let fixedWidth: Font = Font.body.monospaced()

        static let master: Font = {
                #if os(iOS)
                return Font.body
                #else
                return constructFont(size: 14)
                #endif
        }()

        /// Heading
        static let significant: Font = {
                #if os(iOS)
                return Font.body.weight(.medium)
                #else
                return constructFont(size: 16)
                #endif
        }()

        /// Subheadline
        static let copilot: Font = {
                #if os(iOS)
                return Font.subheadline
                #else
                return constructFont(size: 12)
                #endif
        }()

        #if os(macOS)
        private static func constructFont(size: CGFloat) -> Font {
                let SFPro: String = "SF Pro"
                let HelveticaNeue: String = "Helvetica Neue"
                let PingFangHK: String = "PingFang HK"
                let isSFProAvailable: Bool = {
                        if let _ = NSFont(name: SFPro, size: size) {
                                return true
                        } else {
                                return false
                        }
                }()
                let primary: String = isSFProAvailable ? SFPro : HelveticaNeue
                let fallbacks: [String] = {
                        var list: [String] = isSFProAvailable ? [HelveticaNeue] : []
                        let firstWave: [String] = ["ChiuKong Gothic CL", "Advocate Ancient Sans", "Source Han Sans K", "Noto Sans CJK KR", "Sarasa Gothic CL"]
                        for name in firstWave {
                                if let _ = NSFont(name: name, size: size) {
                                        list.append(name)
                                        break
                                }
                        }
                        list.append(PingFangHK)
                        let secondWave: [String] = ["I.MingCP", "I.Ming"]
                        for item in secondWave {
                                if let _ = NSFont(name: item, size: size) {
                                        list.append(item)
                                        break
                                }
                        }
                        if let _ = NSFont(name: "HanaMinB", size: size) {
                                list.append("HanaMinB")
                        }
                        return list
                }()
                let shouldUseSystemFonts: Bool = fallbacks == [PingFangHK]
                if shouldUseSystemFonts {
                        return Font.system(size: size)
                } else {
                        return pairFonts(primary: primary, fallbacks: fallbacks, size: size)
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
