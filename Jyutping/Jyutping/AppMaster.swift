import SwiftUI
import Materials
import CommonExtensions

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

        /// `https://jyutping.app`
        static let websiteAddress: String = "https://jyutping.app"

        /// `https://jyutping.app`
        static let websiteURL: URL = URL(string: websiteAddress)!

        /// `https://apps.apple.com/hk/app/id1509367629`
        static let appStoreAddress: String = "https://apps.apple.com/hk/app/id1509367629"
}

extension AppMaster {

        /// Lookup Cantonese Romanization for text
        /// - Parameter text: Cantonese text
        /// - Returns: Cantonese text and corresponding romanizations
        static func lookup(text: String) -> JyutpingProvider.Response {
                let filtered: String = text.filter({ $0.isIdeographic })
                let search = JyutpingProvider.search(for: filtered)
                guard filtered != text else { return search }
                guard !(filtered.isEmpty) else { return search }
                let transformed = text.textBlocks
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
                                if character.isIdeographic {
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
                return JyutpingProvider.Response(text: combinedText, romanizations: combinedRomanizations)
        }
}

extension AppMaster {

        /// Lookup YingWaaFanWan for the given text
        /// - Parameter text: Character to Lookup
        /// - Returns: An Array of YingWaaFanWan
        static func lookupYingWaaFanWan(for text: String) -> [YingWaaFanWan] {
                guard text.count == 1 else { return [] }
                let character = text.first!
                return YingWaaFanWan.match(for: character)
        }

        /// Lookup ChoHokYuetYamCitYiu for the given text
        /// - Parameter text: Character to Lookup
        /// - Returns: An Array of ChoHokYuetYamCitYiu
        static func lookupChoHokYuetYamCitYiu(for text: String) -> [ChoHokYuetYamCitYiu] {
                guard text.count == 1 else { return [] }
                let character = text.first!
                return ChoHokYuetYamCitYiu.match(for: character)
        }

        /// Lookup FanWanCuetYiu for the given text
        /// - Parameter text: Character to Lookup
        /// - Returns: An Array of FanWanCuetYiu
        static func lookupFanWanCuetYiu(for text: String) -> [FanWanCuetYiu] {
                guard text.count == 1 else { return [] }
                let character = text.first!
                return FanWanCuetYiu.match(for: character)
        }

        /// Lookup GwongWan for the given text
        /// - Parameter text: Character to Lookup
        /// - Returns: An Array of GwongWanCharacter
        static func lookupGwongWan(for text: String) -> [GwongWanCharacter] {
                guard text.count == 1 else { return [] }
                let character = text.first!
                return GwongWan.match(for: character)
        }
}
