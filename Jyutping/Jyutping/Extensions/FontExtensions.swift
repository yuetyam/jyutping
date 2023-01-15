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
                let isSFProAvailable: Bool = found(font: Constant.SFPro)
                let primary: String = isSFProAvailable ? Constant.SFPro : Constant.HelveticaNeue
                let fallbacks: [String] = {
                        var list: [String] = isSFProAvailable ? [Constant.HelveticaNeue] : []
                        let firstWave: [String] = ["ChiuKong Gothic CL", "Advocate Ancient Sans", "Source Han Sans K", "Noto Sans CJK KR", "Sarasa Gothic CL"]
                        for name in firstWave {
                                if found(font: name) {
                                        list.append(name)
                                        break
                                }
                        }
                        list.append(Constant.PingFangHK)
                        let planFonts: [String] = ["Plangothic P1", "Plangothic P2"]
                        for name in planFonts {
                                if found(font: name) {
                                        list.append(name)
                                }
                        }
                        let IMingFonts: [String] = [Constant.IMingCP, Constant.IMing]
                        for name in IMingFonts {
                                if found(font: name) {
                                        list.append(name)
                                        break
                                }
                        }
                        if found(font: Constant.HanaMinB) {
                                list.append(Constant.HanaMinB)
                        }
                        return list
                }()
                let shouldUseSystemFont: Bool = fallbacks == [Constant.PingFangHK]
                guard !shouldUseSystemFont else { return Font.system(size: size) }
                return pairFonts(primary: primary, fallbacks: fallbacks, size: size)
        }

        private static func found(font fontName: String) -> Bool {
                return NSFont(name: fontName, size: 15) != nil
        }

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
