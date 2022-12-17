import SwiftUI
import Materials

struct AppMaster {

        #if os(iOS)
        static func open(appUrl: URL, webUrl: URL) {
                UIApplication.shared.open(appUrl) { success in
                        if !success {
                                UIApplication.shared.open(webUrl)
                        }
                }
        }
        #endif

        static func copy(_ content: String) {
                #if os(iOS)
                UIPasteboard.general.string = content
                #else
                _ = NSPasteboard.general.clearContents()
                _ = NSPasteboard.general.setString(content, forType: .string)
                #endif
        }

        /// 1.0.1 (23)
        static let version: String = {
                let versionString: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "error"
                let buildString: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "null"
                return versionString + " (" + buildString + ")"
        }()
}

extension AppMaster {

        /// Lookup Cantonese Romanization for text
        /// - Parameter text: Cantonese text
        /// - Returns: Cantonese text and corresponding romanizations
        static func lookup(text: String) -> Response {
                let filtered: String = ideographicFilter(text: text)
                let search = Lookup.search(for: filtered)
                guard filtered != text else {
                        return search
                }
                guard !(filtered.isEmpty) else {
                        return search
                }
                let transformed = handleIdeographicBlocks(of: text)
                var handledCount: Int = 0
                var combinedText: String = ""
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
                        var newRomanization: String = ""
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
                return Response(text: combinedText, romanizations: combinedRomanizations)
        }

        private static func ideographicFilter(text: String) -> String {
                return text.unicodeScalars.filter({ $0.properties.isIdeographic }).map({ String($0) }).joined()
        }
        private static func handleIdeographicBlocks(of text: String) -> [(text: String, isIdeographic: Bool)] {
                var blocks: [(String, Bool)] = []
                var ideographicCache: String = ""
                var otherCache: String = ""
                var lastWasIdeographic: Bool = true
                for character in text {
                        let isIdeographic: Bool = character.unicodeScalars.first?.properties.isIdeographic ?? false
                        if isIdeographic {
                                if !lastWasIdeographic && !otherCache.isEmpty {
                                        let newElement: (String, Bool) = (otherCache, false)
                                        blocks.append(newElement)
                                        otherCache = ""
                                }
                                ideographicCache.append(character)
                                lastWasIdeographic = true
                        } else {
                                if lastWasIdeographic && !ideographicCache.isEmpty {
                                        let newElement: (String, Bool) = (ideographicCache, true)
                                        blocks.append(newElement)
                                        ideographicCache = ""
                                }
                                otherCache.append(character)
                                lastWasIdeographic = false
                        }
                }
                if !ideographicCache.isEmpty {
                        let tailElement: (String, Bool) = (ideographicCache, true)
                        blocks.append(tailElement)
                } else if !otherCache.isEmpty {
                        let tailElement: (String, Bool) = (otherCache, false)
                        blocks.append(tailElement)
                }
                return blocks
        }
}
