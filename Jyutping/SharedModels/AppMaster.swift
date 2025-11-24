import SwiftUI
import AppDataSource
import CommonExtensions

struct AppMaster {

        #if os(iOS)
        @MainActor
        static func open(appUrl: URL, webUrl: URL) {
                UIApplication.shared.open(appUrl) { success in
                        if success.negative {
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
                let marketingVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "error"
                let currentProjectVersion: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "null"
                return marketingVersion + " (" + currentProjectVersion + ")"
        }()
}

extension AppMaster {

        static func searchCantoneseLexicons(for text: String) -> [CantoneseLexicon] {
                let ideographicCharacters = text.filter(\.isIdeographic).distinct()
                guard ideographicCharacters.isNotEmpty else { return [CantoneseLexicon(text: text)] }
                let primaryLexicon = AppMaster.lookupCantoneseLexicon(for: text)
                let shouldSearchMoreLexicons: Bool = text.count > 1 && ideographicCharacters.count < 4
                guard shouldSearchMoreLexicons else { return [primaryLexicon] }
                let subLexicons = ideographicCharacters.map({ CantoneseLexicon.search(text: String($0)) })
                return [primaryLexicon] + subLexicons
        }

        /// Lookup Cantonese CantoneseLexicon for the given text.
        /// - Parameter text: Cantonese text.
        /// - Returns: CantoneseLexicon.
        static func lookupCantoneseLexicon(for text: String) -> CantoneseLexicon {
                let filtered: String = text.filter(\.isIdeographic)
                let search = CantoneseLexicon.search(text: filtered)
                guard filtered.count != text.count else { return search }
                guard filtered.isNotEmpty else { return search }
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
                        var characterSequence: String = String.empty
                        var newRomanization: String = String.empty
                        for character in text {
                                if character.isIdeographic {
                                        let shouldInsertSpace: Bool = (characterSequence.last?.isAlphanumeric ?? false) || (newRomanization.last?.isAlphanumeric ?? false)
                                        if shouldInsertSpace {
                                                newRomanization.append(Character.space)
                                        }
                                        if let syllable = syllables.fetch(index) {
                                                newRomanization += syllable
                                                index += 1
                                        }
                                } else {
                                        let shouldInsertSpace: Bool = character.isAlphanumeric && (characterSequence.last?.isIdeographic ?? false)
                                        if shouldInsertSpace {
                                                newRomanization.append(Character.space)
                                        }
                                        newRomanization.append(character)
                                }
                                characterSequence.append(character)
                        }
                        return newRomanization
                }
                let combinedPronunciations = combinedRomanizations.map({ Pronunciation(romanization: $0) })
                return CantoneseLexicon(text: combinedText, pronunciations: combinedPronunciations)
        }
}

extension AppMaster {
        nonisolated(unsafe) private(set) static var confusionEntries: [ConfusionEntry] = []
        static func fetchConfusionEntries() {
                confusionEntries = Confusion.fetch()
        }

        nonisolated(unsafe) private(set) static var surnames: [TextRomanization] = []
        static func fetchSurnames() {
                surnames = HundredFamilySurnames.fetch()
        }

        nonisolated(unsafe) private(set) static var thousandCharacterClassicEntries: [TextRomanization] = []
        static func fetchThousandCharacterClassic() {
                thousandCharacterClassicEntries = ThousandCharacterClassic.fetch()
        }
}
