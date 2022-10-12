import SwiftUI

extension Font {

        private(set) static var candidate: Font = {
                switch AppSettings.candidateFontMode {
                case .default:
                        return constructCandidateFont()
                case .system:
                        return constructCandidateFont(isSystemFontPreferred: true)
                case .custom:
                        let names: [String] = AppSettings.customCandidateFonts
                        let primary: String? = names.first
                        let fallbacks: [String] = Array<String>(names.dropFirst())
                        return constructCandidateFont(primary: primary, fallbacks: fallbacks)
                }
        }()
        static func updateCandidateFont(isSystemFontPreferred: Bool = false, primary: String? = nil, fallbacks: [String]? = nil, size: CGFloat? = nil) {
                candidate = constructCandidateFont(isSystemFontPreferred: isSystemFontPreferred, primary: primary, fallbacks: fallbacks, size: size)
        }

        private static let preferredPrimaryList: [String] = ["ChiuKong Gothic CL", "Advocate Ancient Sans", "Source Han Sans K", "Noto Sans CJK KR", "Sarasa Gothic CL"]
        private static let preferredFallbacks: [String] = ["I.MingCP", "I.Ming", "HanaMinB"]
        private static func constructCandidateFont(isSystemFontPreferred: Bool = false, primary: String? = nil, fallbacks: [String]? = nil, size: CGFloat? = nil) -> Font {
                let fontSize: CGFloat = size ?? AppSettings.candidateFontSize
                guard !isSystemFontPreferred else {
                        return Font.system(size: fontSize)
                }
                let primaryFontName: String = {
                        if let pickedPrimary: String = primary {
                                if let _ = NSFont(name: pickedPrimary, size: fontSize) {
                                        return pickedPrimary
                                }
                        }
                        for name in preferredPrimaryList {
                                if let _ = NSFont(name: name, size: fontSize) {
                                        return name
                                }
                        }
                        return "PingFang HK"
                }()
                let fallbackFontNames: [String] = {
                        if let pickedFallbacks: [String] = fallbacks {
                                if !pickedFallbacks.isEmpty {
                                        var available: [String] = []
                                        for name in pickedFallbacks {
                                                if let _ = NSFont(name: name, size: fontSize) {
                                                        available.append(name)
                                                }
                                        }
                                        return available
                                }
                        }
                        var found: [String] = []
                        if let _ = NSFont(name: preferredFallbacks[0], size: fontSize) {
                                found.append(preferredFallbacks[0])
                        } else if let _ = NSFont(name: preferredFallbacks[1], size: fontSize) {
                                found.append(preferredFallbacks[1])
                        }
                        if let _ = NSFont(name: preferredFallbacks[2], size: fontSize) {
                                found.append(preferredFallbacks[2])
                        }
                        return found
                }()
                if fallbackFontNames.isEmpty {
                        return Font.custom(primaryFontName, size: fontSize)
                } else {
                        return pairFonts(primary: primaryFontName, fallbacks: fallbackFontNames, fontSize: fontSize)
                }
        }

        private(set) static var comment: Font = {
                let commentFontSize: CGFloat = AppSettings.commentFontSize
                switch AppSettings.commentFontMode {
                case .default:
                        return constructFont(size: commentFontSize)
                case .system:
                        return constructFont(size: commentFontSize)
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
                        return constructFont(size: toneFontSize)
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
                        return constructFont(size: labelFontSize)
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
                let pickedList: [String] = {
                        var list: [String] = []
                        if let pickedPrimary = primary {
                                list.append(pickedPrimary)
                        }
                        if let pickedFallbacks = fallbacks {
                                for name in pickedFallbacks {
                                        list.append(name)
                                }
                        }
                        return list
                }()
                guard !pickedList.isEmpty else {
                        return Font.system(size: size, design: .monospaced)
                }
                let check = pickedList.map { name -> String? in
                        if let _ = NSFont(name: name, size: size) {
                                return name
                        } else {
                                return nil
                        }
                }
                let foundList = check.compactMap({ $0 })
                switch foundList.count {
                case 0:
                        return Font.system(size: size, design: .monospaced)
                case 1:
                        let name: String = foundList[0]
                        return Font.custom(name, size: size)
                default:
                        let primaryFontName: String = foundList[0]
                        let fallbackFontNames: [String] = Array<String>(foundList.dropFirst())
                        return pairFonts(primary: primaryFontName, fallbacks: fallbackFontNames, fontSize: size)
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
