import SwiftUI
import CommonExtensions
import AppDataSource

struct TextRomanizationView: View {
        init(text: String, romanization: String) {
                let characters = text.map({ $0 })
                let ideographicCharacters = text.filter(\.isIdeographic).map({ String($0) })
                let syllables = romanization
                        .replacing(/[，。！？、：；]/, with: String.space)
                        .split(separator: Character.space)
                        .map({ String($0) })
                let isEqual: Bool = ideographicCharacters.count == syllables.count
                if isEqual {
                        var pronunciations: [TextRomanization] = []
                        var punctuationCount: Int = 0
                        for index in characters.indices {
                                let character = characters[index]
                                if character.isIdeographic {
                                        let syllable = syllables[index - punctuationCount]
                                        let pronunciation = TextRomanization(text: String(character), romanization: syllable)
                                        pronunciations.append(pronunciation)
                                } else {
                                        punctuationCount += 1
                                        let pronunciation = TextRomanization(text: String(character), romanization: String.empty)
                                        pronunciations.append(pronunciation)
                                }
                        }
                        self.text = text
                        self.romanization = romanization
                        self.isMatched = isEqual
                        self.pronunciations = pronunciations
                } else {
                        self.text = text
                        self.romanization = romanization
                        self.isMatched = isEqual
                        self.pronunciations = []
                }
        }

        private let text: String
        private let romanization: String
        private let isMatched: Bool
        private let pronunciations: [TextRomanization]

        var body: some View {
                if isMatched {
                        HStack(spacing: 1) {
                                ForEach(pronunciations.indices, id: \.self) { index in
                                        CharacterPronunciationView(pronunciation: pronunciations[index])
                                }
                        }
                        .contentShape(Rectangle())
                        .contextMenu {
                                MenuCopyButton(text, title: "General.CopyCantoneseText")
                                MenuCopyButton(romanization, title: "General.CopyJyutpingText")
                        }
                } else {
                        FallbackPronunciationView(text: text, romanization: romanization)
                }
        }
}

private struct CharacterPronunciationView: View {
        let pronunciation: TextRomanization
        var body: some View {
                let text = pronunciation.text
                let romanization = pronunciation.romanization
                if romanization.isEmpty {
                        VStack(spacing: 0) {
                                Text(verbatim: String.space)
                                        .font(.footnote)
                                Text(verbatim: text)
                                        .font(.master)
                        }
                } else {
                        VStack(spacing: 0) {
                                Text(verbatim: romanization)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .font(.footnote)
                                Text(verbatim: text)
                                        .font(.master)
                        }
                        .frame(width: 40)
                }
        }
}

private struct FallbackPronunciationView: View {
        let text: String
        let romanization: String
        var body: some View {
                VStack(spacing: 0) {
                        Text(verbatim: romanization)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .font(.footnote)
                                .textSelection(.enabled)
                        Text(verbatim: text)
                                .font(.master)
                                .textSelection(.enabled)
                }
        }
}
