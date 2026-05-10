import SwiftUI
import CommonExtensions
import AppDataSource

struct RubyStackView: View {
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
                        self.units = pronunciations
                } else {
                        self.text = text
                        self.romanization = romanization
                        self.isMatched = isEqual
                        self.units = []
                }
        }

        private let text: String
        private let romanization: String
        private let isMatched: Bool
        private let units: [TextRomanization]

        var body: some View {
                if isMatched {
                        HStack(spacing: 1) {
                                ForEach(units.indices, id: \.self) { index in
                                        CharacterPronunciationView(unit: units[index])
                                }
                        }
                        .contentShape(.rect)
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
        let unit: TextRomanization
        var body: some View {
                VStack(spacing: 0) {
                        Text(verbatim: unit.romanization.isEmpty ? String.space : unit.romanization)
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                                .font(.annotation)
                                .padding(.leading, 2)
                        Text(verbatim: unit.text)
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                                .font(.word)
                }
                .frame(width: 38)
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
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .font(.master)
                                .textSelection(.enabled)
                }
        }
}
