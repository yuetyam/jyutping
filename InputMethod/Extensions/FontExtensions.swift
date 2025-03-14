import SwiftUI
import CommonExtensions

@MainActor
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
                        return fallback
                case .custom:
                        let names: [String] = AppSettings.customCandidateFonts
                        return combine(fonts: names, size: size) ?? fallback
                }
        }
        private static let preferredCandidateFontNames: [String] = {
                var names: [String] = [PresetConstant.MonaspaceNeon]
                let latinQueue: [String] = [PresetConstant.SFPro, PresetConstant.Inter, PresetConstant.Roboto]
                for name in latinQueue {
                        if found(font: name) {
                                names.append(name)
                                break
                        }
                }
                names.append(PresetConstant.HelveticaNeue)
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
}

@MainActor
extension Font {

        private(set) static var comment: Font = commentFont(size: AppSettings.commentFontSize)
        private(set) static var commentTone: Font = commentFont(size: AppSettings.commentFontSize - 4)
        private(set) static var annotation: Font = commentFont(size: AppSettings.commentFontSize - 2)
        static func updateCommentFont() {
                let commentFontSize: CGFloat = AppSettings.commentFontSize
                let toneFontSize: CGFloat = commentFontSize - 4
                let annotationFontSize: CGFloat = commentFontSize - 2
                comment = commentFont(size: commentFontSize)
                commentTone = commentFont(size: toneFontSize)
                annotation = commentFont(size: annotationFontSize)
        }

        private static func commentFont(size: CGFloat) -> Font {
                lazy var fallback: Font = Font.system(size: size, design: .monospaced)
                switch AppSettings.commentFontMode {
                case .default:
                        guard found(font: PresetConstant.SFMono) || found(font: PresetConstant.MonaspaceNeon) else { return fallback }
                        return combine(fonts: preferredCommentFontNames, size: size) ?? fallback
                case .system:
                        return fallback
                case .custom:
                        let names: [String] = AppSettings.customCommentFonts
                        return combine(fonts: names, size: size) ?? fallback
                }
        }
        private static let preferredCommentFontNames: [String] = {
                var names: [String] = [PresetConstant.SFMono, PresetConstant.MonaspaceNeon]
                let latinQueue: [String] = [PresetConstant.SFPro, PresetConstant.Inter, PresetConstant.Roboto]
                for name in latinQueue {
                        if found(font: name) {
                                names.append(name)
                                break
                        }
                }
                names.append(PresetConstant.HelveticaNeue)
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
}

@MainActor
extension Font {

        private(set) static var label: Font = labelFont(size: AppSettings.labelFontSize)
        static func updateLabelFont() {
                let size: CGFloat = AppSettings.labelFontSize
                label = labelFont(size: size)
        }
        private static func labelFont(size: CGFloat) -> Font {
                switch AppSettings.labelFontMode {
                case .default:
                        switch AppSettings.labelSet {
                        case .arabic, .fullWidthArabic:
                                return Font.system(size: size).monospacedDigit()
                        case .chinese, .capitalizedChinese, .soochow:
                                let preferredFontNameList: [String] = PresetConstant.primaryCJKVQueue + PresetConstant.systemCJKVQueue
                                if let fontName = preferredFontNameList.first(where: { found(font: $0) }) {
                                        return Font.custom(fontName, size: size)
                                } else {
                                        return Font.system(size: size)
                                }
                        case .mahjong:
                                return Font.system(size: size)
                        case .roman, .smallRoman:
                                return Font.system(size: size)
                        }
                case .system:
                        switch AppSettings.labelSet {
                        case .arabic, .fullWidthArabic:
                                return Font.system(size: size).monospacedDigit()
                        case .chinese, .capitalizedChinese, .soochow:
                                return Font.system(size: size)
                        case .mahjong:
                                return Font.system(size: size)
                        case .roman, .smallRoman:
                                return Font.system(size: size)
                        }
                case .custom:
                        let names: [String] = AppSettings.customLabelFonts
                        return combine(fonts: names, size: size) ?? Font.system(size: size)
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
                guard fallbacks.isNotEmpty else { return Font.custom(primary, size: size) }
                let primaryDescriptor: NSFontDescriptor = primaryFont.fontDescriptor
                let descriptors: [NSFontDescriptor] = fallbacks.map { fontName -> NSFontDescriptor in
                        return primaryDescriptor.addingAttributes([.name: fontName])
                }
                let descriptor: NSFontDescriptor = primaryDescriptor.addingAttributes([.cascadeList: descriptors])
                guard let combined: NSFont = NSFont(descriptor: descriptor, size: size) else { return Font.custom(primary, size: size) }
                return Font(combined)
        }
}
