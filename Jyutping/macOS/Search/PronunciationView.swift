#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions

struct PronunciationView: View {

        init(_ pronunciation: Pronunciation) {
                self.romanization = pronunciation.romanization
                self.homophoneText = pronunciation.homophones.isEmpty ? nil : pronunciation.homophones.joined(separator: String.space)
                self.interpretation = pronunciation.interpretation
                self.collocationText = pronunciation.collocations.isEmpty ? nil : pronunciation.collocations.prefix(10).joined(separator: String.space)
                let isSingular: Bool = romanization.filter({ !($0.isLowercaseBasicLatinLetter || $0.isCantoneseToneDigit) }).isEmpty
                self.ipa = isSingular ? Syllable2IPA.IPAText(romanization) : nil
        }

        private let romanization: String
        private let homophoneText: String?
        private let interpretation: String?
        private let collocationText: String?
        private let ipa: String?

        var body: some View {
                VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "讀音")
                                        Text.separator
                                        Text(verbatim: romanization).font(.title3.monospaced())
                                }
                                if let ipa {
                                        Text(verbatim: ipa).font(.title3).foregroundStyle(Color.secondary)
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
                        if let collocationText {
                                HStack {
                                        Text(verbatim: "例詞")
                                        Text.separator
                                        Text(verbatim: collocationText)
                                }
                        }
                }
        }
}

#endif
