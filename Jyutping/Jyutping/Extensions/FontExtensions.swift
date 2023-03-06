import SwiftUI

extension Font {

        static let fixedWidth: Font = Font.body.monospaced()

        #if os(iOS)
        static let master: Font = Font.body
        static let significant: Font = Font.body.weight(.medium)
        static let copilot: Font = Font.subheadline
        #else
        static let master: Font = enhancedFont(size: 14)
        static let significant: Font = enhancedFont(size: 16)
        static let copilot: Font = enhancedFont(size: 12)
        #endif
}

#if os(macOS)

private extension Font {

        static func enhancedFont(size: CGFloat) -> Font {
                return combine(fonts: fontNames, size: size)
        }

        private static let fontNames: [String] = {
                var names: [String] = []
                let primaryQueue: [String] = [Constant.SFPro, Constant.Inter]
                for name in primaryQueue {
                        if found(font: name) {
                                names.append(name)
                                break
                        }
                }
                names.append(Constant.HelveticaNeue)
                let primaryCJKVQueue: [String] = ["Advocate Ancient Sans", "ChiuKong Gothic CL", "Source Han Sans K", "Noto Sans CJK KR"]
                for name in primaryCJKVQueue {
                        if found(font: name) {
                                names.append(name)
                                break
                        }
                }
                let fallbacks: [String] = [Constant.PingFangHK, "Plangothic P1", "Plangothic P2"]
                names.append(contentsOf: fallbacks)
                let IMingFonts: [String] = [Constant.IMingCP, Constant.IMing]
                for name in IMingFonts {
                        if found(font: name) {
                                names.append(name)
                                break
                        }
                }
                names.append(Constant.HanaMinB)
                return names
        }()

        private static func found(font name: String) -> Bool {
                return NSFont(name: name, size: 15) != nil
        }

        private static func combine(fonts names: [String], size: CGFloat) -> Font {
                let fontNames: [String] = names.filter({ found(font: $0) }).uniqued()
                guard let primary = fontNames.first, let primaryFont = NSFont(name: primary, size: size) else { return Font.system(size: size) }
                let fallbacks = fontNames.dropFirst()
                guard !(fallbacks.isEmpty) else { return Font.custom(primary, size: size) }
                let primaryDescriptor: NSFontDescriptor = primaryFont.fontDescriptor
                let descriptors: [NSFontDescriptor] = fallbacks.map { fontName -> NSFontDescriptor in
                        return primaryDescriptor.addingAttributes([.name: fontName])
                }
                let descriptor: NSFontDescriptor = primaryDescriptor.addingAttributes([.cascadeList: descriptors])
                guard let combined: NSFont = NSFont(descriptor: descriptor, size: size) else { return Font.custom(primary, size: size) }
                return Font(combined)
        }
}

#endif
