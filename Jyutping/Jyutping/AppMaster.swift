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
}

extension AppMaster {

        /// Lookup Cantonese Romanization for text
        /// - Parameter text: Cantonese text
        /// - Returns: Cantonese text and corresponding romanizations
        static func lookup(text: String) -> Response {
                let filtered: String = text.filter({ $0.isIdeographic })
                let search = Lookup.search(for: filtered)
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
                return Response(text: combinedText, romanizations: combinedRomanizations)
        }
}

extension AppMaster {

        /// Lookup YingWaaFanWan for the given text
        /// - Parameter text: Character to Lookup
        /// - Returns: An Array of YingWaaFanWan
        static func lookupYingWaaFanWan(for text: String) -> [YingWaaFanWan] {
                guard text.count == 1 else { return [] }
                let character = text.first!
                return YingWaaFanWan.match(for: character).uniqued()
        }

        /// Lookup FanWanCuetYiu for the given text
        /// - Parameter text: Character to Lookup
        /// - Returns: An Array of FanWanCuetYiu
        static func lookupFanWanCuetYiu(for text: String) -> [FanWanCuetYiu] {
                guard text.count == 1 else { return [] }
                let character = text.first!
                return FanWanCuetYiu.match(for: character).uniqued()
        }
}

extension FanWanCuetYiu {
        var  abstract: String {
                return "\(initial)母　\(final)韻　\(yamyeung)\(tone)　\(rhyme)小韻"
        }
        var convertedRomanization: String {
                return romanization.replacingOccurrences(of: "7", with: "1").replacingOccurrences(of: "8", with: "3").replacingOccurrences(of: "9", with: "6")
        }
        var regularJyutping: String {
                return convertedRomanization.replacingOccurrences(of: "^(z|c|s)h", with: "$1", options: .regularExpression)
                        .replacingOccurrences(of: "^nj", with: "j", options: .regularExpression)
                        .replacingOccurrences(of: "o(m|p)$", with: "a$1", options: .regularExpression)
        }
        var ipa: String {
                return FanWanJyutping2IPA.IPA(for: romanization)
        }
}
