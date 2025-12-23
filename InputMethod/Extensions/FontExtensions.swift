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
                switch AppSettings.candidateFontMode {
                case .default:
                        return combine(fonts: preferredCandidateFontNames, size: size) ?? Font.system(size: size)
                case .system:
                        return Font.system(size: size)
                case .custom:
                        let names: [String] = AppSettings.customCandidateFonts
                        return combine(fonts: names, size: size) ?? Font.system(size: size)
                }
        }
        private static let preferredCandidateFontNames: [String] = {
                var names: [String] = [PresetConstant.MonaspaceNeon]
                let latinQueue: [String] = [PresetConstant.SFPro, PresetConstant.Inter, PresetConstant.GoogleSansFlex, PresetConstant.Roboto]
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

        private(set) static var romanization: Font = romanizationFont(size: AppSettings.commentFontSize)
        private(set) static var annotation: Font = annotationFont(size: AppSettings.commentFontSize - 2)
        static func updateCommentFont() {
                let commentFontSize: CGFloat = AppSettings.commentFontSize
                let annotationFontSize: CGFloat = commentFontSize - 2
                romanization = romanizationFont(size: commentFontSize)
                annotation = annotationFont(size: annotationFontSize)
        }
        private static func romanizationFont(size: CGFloat) -> Font {
                switch AppSettings.commentFontMode {
                case .default:
                        return Font.system(size: size)
                case .system:
                        return Font.system(size: size)
                case .custom:
                        let names: [String] = AppSettings.customCommentFonts
                        return combine(fonts: names, size: size) ?? Font.system(size: size)
                }
        }
        private static func annotationFont(size: CGFloat) -> Font {
                switch AppSettings.commentFontMode {
                case .default:
                        return combine(fonts: preferredAnnotationFontNames, size: size) ?? Font.system(size: size)
                case .system:
                        return Font.system(size: size)
                case .custom:
                        let names: [String] = AppSettings.customCommentFonts
                        return combine(fonts: names, size: size) ?? Font.system(size: size)
                }
        }
        private static let preferredAnnotationFontNames: [String] = {
                var names: [String] = []
                let latinQueue: [String] = [PresetConstant.SFPro, PresetConstant.Inter, PresetConstant.GoogleSansFlex, PresetConstant.Roboto]
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

        private(set) static var label: Font = labelFont()
        static func updateLabelFont() {
                label = labelFont()
        }
        private static func labelFont() -> Font {
                let size: CGFloat = AppSettings.labelFontSize
                switch AppSettings.labelFontMode {
                case .default:
                        switch AppSettings.labelSet {
                        case .arabic, .fullWidthArabic:
                                return Font.system(size: size).monospacedDigit()
                        case .chinese, .capitalizedChinese, .soochow, .stems, .branches:
                                if let fontName = PresetConstant.primaryCJKVQueue.first(where: { found(font: $0) }) {
                                        return Font.custom(fontName, size: size)
                                } else {
                                        return Font.system(size: size)
                                }
                        default:
                                return Font.system(size: size)
                        }
                case .system:
                        switch AppSettings.labelSet {
                        case .arabic, .fullWidthArabic:
                                return Font.system(size: size).monospacedDigit()
                        default:
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
                let fontNames: [String] = names.filter({ found(font: $0) }).distinct()
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
