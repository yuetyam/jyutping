#if os(macOS)

import SwiftUI

struct RomanizationLabelView: View {

        let romanization: String
        private let ipa: String?
        private let note: String?

        init(_ romanization: String) {
                self.romanization = romanization
                let isSingular = !(romanization.contains(" "))
                self.ipa = isSingular ? Syllable2IPA.IPAText(romanization) : nil
                let enterTones: Set<Character> = ["1", "3", "6"]
                let enterTails: Set<Character> = ["p", "t", "k"]
                self.note = {
                        guard isSingular else { return nil }
                        guard let tone = romanization.last else { return nil }
                        let isEnterTone: Bool = enterTones.contains(tone)
                        guard !isEnterTone else { return nil }
                        guard let tail = romanization.dropLast().last else { return nil }
                        let isToneSandhi: Bool = enterTails.contains(tail)
                        guard isToneSandhi else { return nil }
                        return "（變調）"
                }()
        }

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
