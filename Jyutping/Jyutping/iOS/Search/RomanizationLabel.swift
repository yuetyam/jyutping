#if os(iOS)

import SwiftUI

struct RomanizationLabel: View {

        let romanization: String
        private let isSingular: Bool
        private let ipa: String?
        private let note: String?

        init(_ romanization: String) {
                self.romanization = romanization
                let isSingular: Bool = !(romanization.contains(" "))
                self.isSingular = isSingular
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
                        if isSingular {
                                Text(verbatim: romanization).font(.fixedWidth)
                        } else {
                                Text(verbatim: romanization)
                        }
                        if let ipa {
                                Text(verbatim: ipa).foregroundColor(.secondary)
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
