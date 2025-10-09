#if os(iOS)

import SwiftUI
import CommonExtensions
import AppDataSource
import Linguistics

struct LexiconView: View {
        let lexicon: CantoneseLexicon
        var body: some View {
                HStack(spacing: 16) {
                        HStack(spacing: 2) {
                                Text(verbatim: "文字").font(.copilot).shallow()
                                Text.separator.font(.copilot)
                                Text(verbatim: lexicon.text)
                        }
                        if lexicon.text.count == 1, let unicode = lexicon.text.first?.codePointsText {
                                Text(verbatim: unicode).font(.footnote.monospaced()).foregroundStyle(Color.secondary)
                        }
                        Spacer()
                        Speaker {
                                Speech.speak(lexicon.text, isRomanization: false)
                        }
                }
                ForEach(lexicon.pronunciations.indices, id: \.self) { index in
                        PronunciationView(lexicon.pronunciations[index])
                }
                if let unihanDefinition = lexicon.unihanDefinition {
                        HStack(spacing: 2) {
                                Text(verbatim: "英文").font(.copilot).shallow()
                                Text.separator.font(.copilot)
                                Text(verbatim: unihanDefinition).font(.subheadline)
                        }
                }
        }
}

private struct PronunciationView: View {

        init(_ pronunciation: Pronunciation) {
                let romanization: String = pronunciation.romanization
                let homophones: [String] = pronunciation.homophones
                let collocations: [String] = pronunciation.collocations
                self.romanization = romanization
                self.homophoneText = homophones.isEmpty ? nil : homophones.joined(separator: String.space)
                self.collocationText = collocations.isEmpty ? nil : collocations.prefix(5).joined(separator: String.space)
                self.collocationSpeechText = collocations.isEmpty ? nil : collocations.prefix(5).joined(separator: "；")
                self.descriptions = pronunciation.descriptions
                let isSingular: Bool = romanization.filter({ $0.isLowercaseBasicLatinLetter || $0.isCantoneseToneDigit }).count == romanization.count
                self.isSingular = isSingular
                self.ipa = isSingular ? JyutpingSyllable2IPA.IPAText(of: romanization) : nil
        }

        private let romanization: String
        private let homophoneText: String?
        private let collocationText: String?
        private let collocationSpeechText: String?
        private let descriptions: [String]
        private let isSingular: Bool
        private let ipa: String?

        var body: some View {
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack(spacing: 2) {
                                        Text(verbatim: "讀音").shallow()
                                        Text.separator
                                        Text(verbatim: romanization).font(isSingular ? .fixedWidth : .body)
                                }
                                if let ipa {
                                        Text(verbatim: ipa).font(.ipa).foregroundStyle(Color.secondary)
                                }
                                Spacer()
                                Speaker(romanization)
                        }
                        if let homophoneText {
                                HStack(spacing: 2) {
                                        Text(verbatim: "同音").shallow()
                                        Text.separator
                                        Text(verbatim: homophoneText).font(.body)
                                }
                        }
                        if let collocationText {
                                HStack(spacing: 2) {
                                        Text(verbatim: "詞例").shallow()
                                        Text.separator
                                        Text(verbatim: collocationText).font(.body)
                                        Spacer()
                                        Speaker {
                                                Speech.speak(collocationSpeechText ?? collocationText, isRomanization: false)
                                        }
                                }
                        }
                        ForEach(descriptions.indices, id: \.self) { index in
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                        Text(verbatim: "釋義").shallow()
                                        Text.separator
                                        Text(verbatim: descriptions[index]).font(.callout)
                                }
                                .padding(.vertical, 2)
                        }
                }
                .font(.copilot)
        }
}

#endif
