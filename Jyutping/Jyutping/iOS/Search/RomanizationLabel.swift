#if os(iOS)

import SwiftUI

struct RomanizationLabel: View {

        init(_ romanization: String) {
                self.romanization = romanization
                let isSingular: Bool = romanization.filter({ !($0.isLowercaseBasicLatinLetter || $0.isCantoneseToneDigit) }).isEmpty
                self.isSingular = isSingular
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
        private let isSingular: Bool
        private let ipa: String?
        private let note: String?

        private static let enterTones: Set<Character> = ["1", "3", "6"]
        private static let enterTails: Set<Character> = ["p", "t", "k"]

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
