import UIKit
import LookupData

struct AppMaster {

        static func open(appUrl: URL, webUrl: URL) {
                UIApplication.shared.open(appUrl) { success in
                        if !success {
                                UIApplication.shared.open(webUrl)
                        }
                }
        }

        /// Lookup Cantonese Romanization for text
        /// - Parameter text: Cantonese text
        /// - Returns: Cantonese text and corresponding romanizations
        static func lookup(text: String) -> (text: String, romanizations: [String]) {
                let filtered: String = text.filtered()
                let search = LookupData.advancedSearch(for: filtered)
                guard filtered != text else {
                        return search
                }
                guard !(filtered.isEmpty) else {
                        return search
                }
                let transformed = text.ideographicBlocks
                var handledCount: Int = 0
                var combinedText: String = .empty
                for item in transformed {
                        if item.isIdeographic {
                                let tail = search.text.dropFirst(handledCount)
                                let suffixCount = tail.count - item.text.count
                                let selected = tail.dropLast(suffixCount)
                                combinedText += selected
                                handledCount += item.text.count
                        } else {
                                combinedText += item.text
                        }
                }
                let combinedRomanizations = search.romanizations.map { romanization -> String in
                        let syllables: [String] = romanization.components(separatedBy: " ")
                        var index: Int = 0
                        var newRomanization: String = .empty
                        var lastWasIdeographic: Bool = false
                        for character in text {
                                let isIdeographic: Bool = character.unicodeScalars.first?.properties.isIdeographic ?? false
                                if isIdeographic {
                                        newRomanization += (syllables[index] + " ")
                                        index += 1
                                        lastWasIdeographic = true
                                } else {
                                        if lastWasIdeographic {
                                                newRomanization = String(newRomanization.dropLast())
                                        }
                                        newRomanization.append(character)
                                        lastWasIdeographic = false
                                }
                        }
                        return newRomanization.trimmingCharacters(in: .whitespaces)
                }
                return (combinedText, combinedRomanizations)
        }
}


struct Device {

        static let isPhone: Bool = {
                switch UITraitCollection.current.userInterfaceIdiom {
                case .phone, .unspecified:
                        return true
                default:
                        return false
                }
        }()

        static let isPad: Bool = UITraitCollection.current.userInterfaceIdiom == .pad

        /// Example: iPhone 13 Pro Max
        static let modelName: String = UIDevice.modelName

        /// Example: iPadOS 15.2
        static let system: String = UIDevice.current.systemName + " " + UIDevice.current.systemVersion
}
