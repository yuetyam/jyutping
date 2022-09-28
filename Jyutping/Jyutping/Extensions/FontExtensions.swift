import SwiftUI

extension Font {

        static let candidate: Font = {
                let primaryFontName: String = {
                        let preferredList: [String] = ["Advocate Ancient Sans", "ChiuKong Gothic CL", "Source Han Sans K", "Noto Sans CJK KR", "Sarasa Gothic CL"]
                        for name in preferredList {
                                if let _ = NSFont(name: name, size: 17) {
                                        return name
                                }
                        }
                        return "PingFang HK"
                }()
                let fallbackFontNames: [String] = {
                        let size: CGFloat = 17
                        let expected: [String] = ["I.MingCP", "I.Ming", "HanaMinB"]
                        var found: [String] = []
                        if let _ = NSFont(name: expected[0], size: size) {
                                found.append(expected[0])
                        } else if let _ = NSFont(name: expected[1], size: size) {
                                found.append(expected[1])
                        }
                        if let _ = NSFont(name: expected[2], size: size) {
                                found.append(expected[2])
                        }
                        return found
                }()
                if fallbackFontNames.isEmpty {
                        return Font.custom(primaryFontName, size: AppSettings.candidateFontSize)
                } else {
                        return pairFonts(primary: primaryFontName, fallbacks: fallbackFontNames, fontSize: AppSettings.candidateFontSize)
                }
        }()

        static let serial: Font = Font.title3.monospacedDigit()
        static let comment: Font = Font.title3.monospaced()
        static let secondaryComment: Font = Font.body.monospaced()

        private static func pairFonts(primary: String, fallbacks: [String], fontSize: CGFloat) -> Font {
                let originalFont: NSFont = NSFont(name: primary, size: fontSize) ?? .systemFont(ofSize: fontSize)
                let originalDescriptor: NSFontDescriptor = originalFont.fontDescriptor
                let fallbackDescriptors: [NSFontDescriptor] = fallbacks.map { fontName -> NSFontDescriptor in
                        return originalDescriptor.addingAttributes([.name: fontName])
                }
                let pairedDescriptor: NSFontDescriptor = originalDescriptor.addingAttributes([.cascadeList : fallbackDescriptors])
                let pairedFont: NSFont = NSFont(descriptor: pairedDescriptor, size: fontSize) ?? .systemFont(ofSize: fontSize)
                return Font(pairedFont)
        }
}
