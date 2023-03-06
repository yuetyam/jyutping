import SwiftUI

extension Font {

        private(set) static var candidate: Font = candidateFont()
        static func updateCandidateFont() {
                candidate = candidateFont()
        }

        private static func candidateFont() -> Font {
                let size: CGFloat = AppSettings.candidateFontSize
                lazy var fallback: Font = Font.system(size: size)
                switch AppSettings.candidateFontMode {
                case .default:
                        return combine(fonts: preferredCandidateFontNames, size: size) ?? fallback
                case .system:
                        return Font.system(size: size)
                case .custom:
                        let names: [String] = AppSettings.customCandidateFonts
                        return combine(fonts: names, size: size) ?? combine(fonts: preferredCandidateFontNames, size: size) ?? fallback
                }
        }
        private static let preferredCandidateFontNames: [String] = {
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
}

extension Font {

        private(set) static var comment: Font = commentFont(size: AppSettings.commentFontSize)
        private(set) static var commentTone: Font = {
                let toneFontSize: CGFloat = AppSettings.commentFontSize - 4
                return commentFont(size: toneFontSize)
        }()
        static func updateCommentFont() {
                let commentFontSize: CGFloat = AppSettings.commentFontSize
                let toneFontSize: CGFloat = commentFontSize - 4
                comment = commentFont(size: commentFontSize)
                commentTone = commentFont(size: toneFontSize)
        }

        private static func commentFont(size: CGFloat) -> Font {
                lazy var fallback: Font = Font.system(size: size, design: .monospaced)
                switch AppSettings.commentFontMode {
                case .default:
                        guard found(font: Constant.SFMono) else { return fallback }
                        return combine(fonts: preferredCommentFontNames, size: size) ?? fallback
                case .system:
                        return Font.system(size: size)
                case .custom:
                        let names: [String] = AppSettings.customCommentFonts
                        return combine(fonts: names, size: size) ?? combine(fonts: preferredCommentFontNames, size: size) ?? fallback
                }
        }
        private static let preferredCommentFontNames: [String] = {
                var names: [String] = [Constant.SFMono]
                let secondaryQueue: [String] = [Constant.SFPro, Constant.Inter]
                for name in secondaryQueue {
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
}

extension Font {

        private(set) static var label: Font = labelFont(size: AppSettings.labelFontSize)
        private(set) static var labelDot: Font = Font.system(size: AppSettings.labelFontSize)
        static func updateLabelFont() {
                let size: CGFloat = AppSettings.labelFontSize
                label = labelFont(size: size)
                labelDot = Font.system(size: size)
        }
        private static func labelFont(size: CGFloat) -> Font {
                lazy var fallback: Font = Font.system(size: size).monospacedDigit()
                switch AppSettings.labelFontMode {
                case .default:
                        return fallback
                case .system:
                        return fallback
                case .custom:
                        let names: [String] = AppSettings.customLabelFonts
                        return combine(fonts: names, size: size) ?? fallback
                }
        }
}

private extension Font {

        static func found(font name: String) -> Bool {
                return NSFont(name: name, size: 15) != nil
        }

        static func combine(fonts names: [String], size: CGFloat) -> Font? {
                let fontNames: [String] = names.filter({ found(font: $0) }).uniqued()
                guard let primary = fontNames.first, let primaryFont = NSFont(name: primary, size: size) else { return nil }
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
