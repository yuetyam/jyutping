#if os(macOS)

import SwiftUI
import Materials
import CommonExtensions

struct PronunciationView: View {

        init(_ pronunciation: Pronunciation) {
                self.romanization = pronunciation.romanization
                self.homophoneText = pronunciation.homophones.isEmpty ? nil : pronunciation.homophones.joined(separator: String.space)
                self.interpretation = pronunciation.interpretation
                let isSingular: Bool = romanization.filter({ !($0.isLowercaseBasicLatinLetter || $0.isCantoneseToneDigit) }).isEmpty
                self.isSingular = isSingular
                self.ipa = isSingular ? Syllable2IPA.IPAText(romanization) : nil
                self.mark = {
                        guard isSingular else { return nil }
                        let tail = pronunciation.romanization.suffix(2)
                        return Self.sandhiTails.contains(String(tail)) ? "變調" : nil
                }()
        }

        private let romanization: String
        private let homophoneText: String?
        private let interpretation: String?

        private let isSingular: Bool
        private let ipa: String?
        private let mark: String?
        private static let sandhiTails: Set<String> = ["p2", "t2", "k2"]

        var body: some View {
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "讀音")
                                        Text.separator
                                        Text(verbatim: romanization).font(.title3.monospaced())
                                }
                                if let ipa {
                                        Text(verbatim: ipa).font(.title3).foregroundStyle(Color.secondary)
                                }
                                if let mark {
                                        Text(verbatim: mark).foregroundStyle(Color.secondary)
                                }
                                Spacer()
                                Speaker(romanization)
                        }
                        if let homophoneText {
                                HStack {
                                        Text(verbatim: "同音")
                                        Text.separator
                                        Text(verbatim: homophoneText)
                                }
                        }
                        if let interpretation {
                                HStack {
                                        Text(verbatim: "釋義")
                                        Text.separator
                                        Text(verbatim: interpretation)
                                }
                        }
                }
        }
}

#endif
