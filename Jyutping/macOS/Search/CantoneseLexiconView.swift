#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct CantoneseLexiconView: View {
        let lexicon: CantoneseLexicon
        var body: some View {
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "文字").shallow()
                                        Text.separator
                                        Text(verbatim: lexicon.text).font(.display)
                                }
                                if lexicon.text.count == 1, let unicode = lexicon.text.first?.codePointsText {
                                        Text(verbatim: unicode).font(.fixedWidth).airy()
                                }
                                Spacer()
                                Speaker {
                                        Speech.speak(lexicon.text, isRomanization: false)
                                }
                        }
                        ForEach(lexicon.pronunciations.indices, id: \.self) { index in
                                Divider()
                                PronunciationView(lexicon.pronunciations[index])
                        }
                        if let unihanDefinition = lexicon.unihanDefinition {
                                Divider()
                                HStack(alignment: .firstTextBaseline) {
                                        Text(verbatim: "英文").shallow()
                                        Text.separator
                                        Text(verbatim: unihanDefinition)
                                        Spacer()
                                }
                        }
                }
                .block()
        }
}

private struct PronunciationView: View {

        init(_ pronunciation: Pronunciation) {
                let romanization: String = pronunciation.romanization
                let homophones: [String] = pronunciation.homophones
                let collocations: [String] = pronunciation.collocations
                self.romanization = romanization
                let isSingular: Bool = romanization.filter({ $0.isLowercaseBasicLatinLetter || $0.isCantoneseToneDigit }).count == romanization.count
                self.ipa = isSingular ? JyutpingSyllable2IPA.IPAText(of: romanization) : nil
                self.homophoneText = homophones.isEmpty ? nil : homophones.joined(separator: String.space)
                self.collocationText = collocations.isEmpty ? nil : collocations.prefix(8).joined(separator: String.space)
                self.collocationSpeechText = collocations.isEmpty ? nil : collocations.prefix(8).joined(separator: "；")
                self.descriptions = pronunciation.descriptions
        }

        private let romanization: String
        private let ipa: String?
        private let homophoneText: String?
        private let collocationText: String?
        private let collocationSpeechText: String?
        private let descriptions: [String]

        var body: some View {
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "讀音").shallow()
                                        Text.separator
                                        Text(verbatim: romanization).font(.title3).monospaced()
                                }
                                if let ipa {
                                        Text(verbatim: ipa).font(.ipa).airy()
                                }
                                Spacer()
                                Speaker(romanization)
                        }
                        if let homophoneText {
                                HStack {
                                        Text(verbatim: "同音").shallow()
                                        Text.separator
                                        Text(verbatim: homophoneText)
                                }
                        }
                        if let collocationText {
                                HStack {
                                        Text(verbatim: "詞例").shallow()
                                        Text.separator
                                        Text(verbatim: collocationText)
                                        Spacer()
                                        Speaker {
                                                Speech.speak(collocationSpeechText ?? collocationText, isRomanization: false)
                                        }
                                }
                        }
                        ForEach(descriptions.indices, id: \.self) { index in
                                HStack(alignment: .firstTextBaseline) {
                                        Text(verbatim: "釋義").shallow()
                                        Text.separator
                                        Text(verbatim: descriptions[index]).lineSpacing(4)
                                }
                                .padding(.vertical, 2)
                        }
                }
        }
}

#endif
