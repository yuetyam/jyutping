#if os(macOS)

import SwiftUI

struct RomanizationLabelView: View {

        init(_ romanization: String) {
                self.romanization = romanization
                let isSingular: Bool = romanization.filter({ !($0.isLowercaseBasicLatinLetter || $0.isCantoneseToneDigit) }).isEmpty
                self.ipa = isSingular ? Syllable2IPA.IPAText(romanization) : nil
                self.note = {
                        guard isSingular else { return nil }
                        guard let tone = romanization.last else { return nil }
                        let isRegularEnterTone: Bool = Self.enterTones.contains(tone)
                        guard !isRegularEnterTone else { return nil }
                        guard let tail = romanization.dropLast().last else { return nil }
                        let isToneSandhi: Bool = Self.enterTails.contains(tail)
                        guard isToneSandhi else { return nil }
                        return "（變調）"
                }()
        }

        private let romanization: String
        private let ipa: String?
        private let note: String?

        private static let enterTones: Set<Character> = ["1", "3", "6"]
        private static let enterTails: Set<Character> = ["p", "t", "k"]

        var body: some View {
                HStack(spacing: 16) {
                        Text(verbatim: romanization).font(.title3.monospaced())
                        if let ipa {
                                Text(verbatim: ipa).font(.title3).foregroundColor(.secondary)
                        }
                        if let note {
                                Text(verbatim: note).font(.copilot)
                        }
                        Spacer()
                        Speaker(romanization)
                }
        }
}

#endif
