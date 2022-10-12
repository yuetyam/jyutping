import SwiftUI

extension Font {

        private(set) static var candidate: Font = {
                let size: CGFloat = AppSettings.candidateFontSize
                switch AppSettings.candidateFontMode {
                case .default:
                        return constructDefaultCandidateFont(size: size)
                case .system:
                        return Font.system(size: size)
                case .custom:
                        let names: [String] = AppSettings.customCandidateFonts
                        let primary: String? = names.first
                        let fallbacks: [String] = Array<String>(names.dropFirst())
                        return constructCandidateFont(primary: primary, fallbacks: fallbacks, size: size)
                }
        }()
        static func updateCandidateFont(isSystemFontPreferred: Bool = false, primary: String? = nil, fallbacks: [String]? = nil, size: CGFloat? = nil) {
                let fontSize: CGFloat = size ?? AppSettings.candidateFontSize
                candidate = {
                        if isSystemFontPreferred {
                                return Font.system(size: fontSize)
                        } else {
                                return constructCandidateFont(primary: primary, fallbacks: fallbacks, size: fontSize)
                        }
                }()
        }

        private static func constructCandidateFont(primary: String? = nil, fallbacks: [String]? = nil, size: CGFloat? = nil) -> Font {
                let fontSize: CGFloat = size ?? AppSettings.candidateFontSize
                guard let primary else { return constructDefaultCandidateFont(size: fontSize) }
                guard let _ = NSFont(name: primary, size: fontSize) else { return constructDefaultCandidateFont(size: fontSize) }
                let foundFallbacks: [String] = {
                        guard let fallbacks else { return [] }
                        guard !(fallbacks.isEmpty) else { return [] }
                        var available: [String] = []
                        for name in fallbacks where name != primary {
                                if let _ = NSFont(name: name, size: fontSize) {
                                        available.append(name)
                                }
                        }
                        return available.uniqued()
                }()
                if foundFallbacks.isEmpty {
                        return Font.custom(primary, size: fontSize)
                } else {
                        return pairFonts(primary: primary, fallbacks: foundFallbacks, fontSize: fontSize)
                }
        }
        private static func constructDefaultCandidateFont(size: CGFloat? = nil) -> Font {
                let fontSize: CGFloat = size ?? AppSettings.candidateFontSize
                let primary: String = {
                        if let _ = NSFont(name: "SF Pro", size: fontSize) {
                                return "SF Pro"
                        } else {
                                return "Helvetica Neue"
                        }
                }()
                let fallbacks: [String] = {
                        var list: [String] = ["PingFang HK"]
                        let firstWave: [String] = ["ChiuKong Gothic CL", "Advocate Ancient Sans", "Source Han Sans K", "Noto Sans CJK KR", "Sarasa Gothic CL"]
                        for name in firstWave {
                                if let _ = NSFont(name: name, size: fontSize) {
                                        list = [name]
                                        break
                                }
                        }
                        let secondWave: [String] = ["I.MingCP", "I.Ming"]
                        for item in secondWave {
                                if let _ = NSFont(name: item, size: fontSize) {
                                        list.append(item)
                                        break
                                }
                        }
                        if let _ = NSFont(name: "HanaMinB", size: fontSize) {
                                list.append("HanaMinB")
                        }
                        return list
                }()
                return pairFonts(primary: primary, fallbacks: fallbacks, fontSize: fontSize)
        }

        private(set) static var comment: Font = {
                let commentFontSize: CGFloat = AppSettings.commentFontSize
                switch AppSettings.commentFontMode {
                case .default:
                        return constructFont(size: commentFontSize)
                case .system:
                        return Font.system(size: commentFontSize, design: .monospaced)
                case .custom:
                        let names: [String] = AppSettings.customCommentFonts
                        let primary: String? = names.first
                        let fallbacks: [String] = Array<String>(names.dropFirst())
                        return constructFont(primary: primary, fallbacks: fallbacks, size: commentFontSize)
                }
        }()
        static func updateCommentFont(primary: String? = nil, fallbacks: [String]? = nil, size: CGFloat? = nil) {
                let commentFontSize: CGFloat = size ?? AppSettings.commentFontSize
                let toneFontSize: CGFloat = commentFontSize - 4
                comment = constructFont(primary: primary, fallbacks: fallbacks, size: commentFontSize)
                commentTone = constructFont(primary: primary, fallbacks: fallbacks, size: toneFontSize)
        }
        private(set) static var commentTone: Font = {
                let toneFontSize: CGFloat = AppSettings.commentFontSize - 4
                switch AppSettings.commentFontMode {
                case .default:
                        return constructFont(size: toneFontSize)
                case .system:
                        return Font.system(size: toneFontSize, design: .monospaced)
                case .custom:
                        let names: [String] = AppSettings.customCommentFonts
                        let primary: String? = names.first
                        let fallbacks: [String] = Array<String>(names.dropFirst())
                        return constructFont(primary: primary, fallbacks: fallbacks, size: toneFontSize)
                }
        }()
        private(set) static var label: Font = {
                let labelFontSize: CGFloat = AppSettings.labelFontSize
                switch AppSettings.labelFontMode {
                case .default:
                        return constructFont(size: labelFontSize)
                case .system:
                        return Font.system(size: labelFontSize, design: .monospaced)
                case .custom:
                        let names: [String] = AppSettings.customLabelFonts
                        let primary: String? = names.first
                        let fallbacks: [String] = Array<String>(names.dropFirst())
                        return constructFont(primary: primary, fallbacks: fallbacks, size: labelFontSize)
                }
        }()
        static func updateLabelFont(primary: String? = nil, fallbacks: [String]? = nil, size: CGFloat? = nil) {
                let labelFontSize: CGFloat = size ?? AppSettings.labelFontSize
                label = constructFont(primary: primary, fallbacks: fallbacks, size: labelFontSize)
                labelDot = Font.system(size: labelFontSize)
        }
        private(set) static var labelDot: Font = Font.system(size: AppSettings.labelFontSize)

        private static func constructFont(primary: String? = nil, fallbacks: [String]? = nil, size: CGFloat) -> Font {
                guard let primary else { return Font.system(size: size, design: .monospaced) }
                guard let _ = NSFont(name: primary, size: size) else { return Font.system(size: size, design: .monospaced) }
                let foundFallbacks: [String] = {
                        guard let fallbacks else { return [] }
                        guard !(fallbacks.isEmpty) else { return [] }
                        var available: [String] = []
                        for name in fallbacks where name != primary {
                                if let _ = NSFont(name: name, size: size) {
                                        available.append(name)
                                }
                        }
                        return available.uniqued()
                }()
                if foundFallbacks.isEmpty {
                        return Font.custom(primary, size: size)
                } else {
                        return pairFonts(primary: primary, fallbacks: foundFallbacks, fontSize: size)
                }
        }

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
