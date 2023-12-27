import SwiftUI
import AppDataSource
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

        /// Example: 1.0.1 (23)
        static let version: String = {
                let marketingVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.1.0"
                let currentProjectVersion: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "1"
                return marketingVersion + " (" + currentProjectVersion + ")"
        }()

        static let websiteAddress: String = "https://jyutping.app"
        static let websiteURL: URL = URL(string: websiteAddress)!

        static let jyutping4MacAddress: String = "https://jyutping.app/mac"
        static let privacyPolicyAddress: String = "https://jyutping.app/privacy"
        static let faqAddress: String = "https://jyutping.app/faq"

        static let sourceCodeAddress: String = "https://github.com/yuetyam/jyutping"
        static let appStoreAddress: String = "https://apps.apple.com/hk/app/id1509367629"
        static let emailAddress: String = "support@jyutping.app"
}

extension AppMaster {

        /// Lookup Cantonese CantoneseLexicon for the given text.
        /// - Parameter text: Cantonese text.
        /// - Returns: CantoneseLexicon.
        static func lookupCantoneseLexicon(for text: String) -> CantoneseLexicon {
                let filtered: String = text.filter(\.isIdeographic)
                let search = CantoneseLexicon.search(text: filtered)
                guard filtered.count != text.count else { return search }
                guard !(filtered.isEmpty) else { return search }
                let transformed = text.textBlocks
                var handledCount: Int = 0
                var combinedText: String = String.empty
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
                let combinedRomanizations = search.pronunciations.map(\.romanization).map { romanization -> String in
                        let syllables: [String] = romanization.components(separatedBy: String.space)
                        var index: Int = 0
                        var newRomanization: String = String.empty
                        var lastWasIdeographic: Bool = false
                        for character in text {
                                if character.isIdeographic {
                                        newRomanization += (syllables[index] + String.space)
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
                let combinedPronunciations = combinedRomanizations.map({ Pronunciation(romanization: $0) })
                return CantoneseLexicon(text: combinedText, pronunciations: combinedPronunciations)
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

extension AppMaster {
        private(set) static var confusionEntries: [ConfusionEntry] = []
        static func fetchConfusionEntries() {
                confusionEntries = Confusion.fetch()
        }

        private(set) static var surnames: [LineUnit] = []
        static func fetchSurnames() {
                surnames = BaakGaaSing.fetch()
        }

        private(set) static var cinZiManUnits: [LineUnit] = []
        static func fetchCinZiManUnits() {
                cinZiManUnits = CinZiMan.fetch()
        }
}
