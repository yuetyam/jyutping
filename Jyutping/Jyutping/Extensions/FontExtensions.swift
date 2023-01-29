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
                let shouldUseSystemFont: Bool = fontNames.count == 2
                guard !shouldUseSystemFont else { return Font.system(size: size) }
                return combinedFont(from: fontNames, size: size)
        }

        private static let fontNames: [String] = {
                var names: [String] = []
                if found(font: Constant.SFPro) {
                        names.append(Constant.SFPro)
                }
                names.append(Constant.HelveticaNeue)
                let expected: [String] = ["ChiuKong Gothic CL", "Advocate Ancient Sans", "Source Han Sans K", "Noto Sans CJK KR", "Sarasa Gothic CL"]
                for name in expected {
                        if found(font: name) {
                                names.append(name)
                                break
                        }
                }
                names.append(Constant.PingFangHK)
                let planFonts: [String] = ["Plangothic P1", "Plangothic P2"]
                for name in planFonts where found(font: name) {
                        names.append(name)
                }
                let IMingFonts: [String] = [Constant.IMingCP, Constant.IMing]
                for name in IMingFonts {
                        if found(font: name) {
                                names.append(name)
                                break
                        }
                }
                if found(font: Constant.HanaMinB) {
                        names.append(Constant.HanaMinB)
                }
                return names
        }()

        private static func found(font name: String) -> Bool {
                return NSFont(name: name, size: 15) != nil
        }

        private static func combinedFont(from names: [String], size: CGFloat) -> Font {
                guard let primary = names.first, let primaryFont = NSFont(name: primary, size: size) else { return Font.system(size: size) }
                let fallbacks: [String] = names.dropFirst().compactMap({ $0 })
                let primaryDescriptor: NSFontDescriptor = primaryFont.fontDescriptor
                let descriptors: [NSFontDescriptor] = fallbacks.map { name -> NSFontDescriptor in
                        return primaryDescriptor.addingAttributes([.name: name])
                }
                let descriptor: NSFontDescriptor = primaryDescriptor.addingAttributes([.cascadeList : descriptors])
                guard let combined: NSFont = NSFont(descriptor: descriptor, size: size) else { return Font.system(size: size) }
                return Font(combined)
        }
}

#endif
