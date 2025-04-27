import SwiftUI
import CommonExtensions

extension Font {

        static let fixedWidth: Font = Font.body.monospaced()

        #if os(macOS)
        static let master: Font = enhancedFont(size: 14)
        static let significant: Font = enhancedFont(size: 16)
        static let copilot: Font = enhancedFont(size: 12)
        static let ipa: Font = enhancedFont(size: 15)
        #else
        static let master: Font = Font.body
        static let significant: Font = Font.headline
        static let copilot: Font = Font.subheadline
        static let ipa: Font = enhancedFont(size: 17)
        #endif
}

private extension Font {

        static func enhancedFont(size: CGFloat) -> Font {
                return combine(fonts: preferredFontNames, size: size)
        }

        private static let preferredFontNames: [String] = {
                var names: [String] = []
                let primaryList: [String] = [PresetConstant.SFPro, PresetConstant.Roboto, PresetConstant.Arial, PresetConstant.Inter, PresetConstant.HelveticaNeue]
                for name in primaryList {
                        if found(font: name) {
                                names.append(name)
                        }
                }
                var shouldConsiderSupplementaryFonts: Bool = true
                for name in PresetConstant.primaryCJKVQueue {
                        if found(font: name) {
                                names.append(name)
                                shouldConsiderSupplementaryFonts = false
                                break
                        }
                }
                for name in PresetConstant.systemCJKVQueue {
                        if found(font: name) {
                                names.append(name)
                                break
                        }
                }
                if shouldConsiderSupplementaryFonts {
                        for name in PresetConstant.supplementaryCJKVQueue {
                                if found(font: name) {
                                        names.append(name)
                                        break
                                }
                        }
                }
                names.append(contentsOf: PresetConstant.fallbackCJKVList)
                return names
        }()

        private static func found(font name: String) -> Bool {
                #if os(macOS)
                return NSFont(name: name, size: 15) != nil
                #else
                return UIFont(name: name, size: 15) != nil
                #endif
        }

        #if os(macOS)
        private static func combine(fonts names: [String], size: CGFloat) -> Font {
                let fontNames: [String] = names.filter({ found(font: $0) }).uniqued()
                guard let primary = fontNames.first, let primaryFont = NSFont(name: primary, size: size) else { return Font.system(size: size) }
                let fallbacks = fontNames.dropFirst()
                guard fallbacks.isNotEmpty else { return Font.custom(primary, size: size) }
                let primaryDescriptor: NSFontDescriptor = primaryFont.fontDescriptor
                let descriptors: [NSFontDescriptor] = fallbacks.map { fontName -> NSFontDescriptor in
                        return primaryDescriptor.addingAttributes([.name: fontName])
                }
                let descriptor: NSFontDescriptor = primaryDescriptor.addingAttributes([.cascadeList: descriptors])
                guard let combined: NSFont = NSFont(descriptor: descriptor, size: size) else { return Font.custom(primary, size: size) }
                return Font(combined)
        }
        #else
        private static func combine(fonts names: [String], size: CGFloat) -> Font {
                let fontNames: [String] = names.filter({ found(font: $0) }).uniqued()
                guard let primary = fontNames.first, let primaryFont = UIFont(name: primary, size: size) else { return Font.system(size: size) }
                let fallbacks = fontNames.dropFirst()
                guard fallbacks.isNotEmpty else { return Font.custom(primary, size: size) }
                let primaryDescriptor: UIFontDescriptor = primaryFont.fontDescriptor
                let descriptors: [UIFontDescriptor] = fallbacks.map { fontName -> UIFontDescriptor in
                        return primaryDescriptor.addingAttributes([.name: fontName])
                }
                let descriptor: UIFontDescriptor = primaryDescriptor.addingAttributes([.cascadeList: descriptors])
                let combined: UIFont = UIFont(descriptor: descriptor, size: size)
                return Font(combined)
        }
        #endif
}
