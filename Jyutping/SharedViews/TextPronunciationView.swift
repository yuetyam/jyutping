import SwiftUI
import CommonExtensions

struct TextPronunciationView: View {

        // TODO: Handle Non-CJKV Characters

        init(text: String, romanization: String) {
                let characters = text.map({ String($0) })
                let syllables = romanization.split(separator: Character.space).map({ String($0) })
                let isEqual: Bool = characters.count == syllables.count
                if isEqual {
                        var pronunciations: [CharacterPronunciation] = []
                        for index in 0..<characters.count {
                                let character = characters[index]
                                let syllable = syllables[index]
                                let pronunciation = CharacterPronunciation(cantonese: character, romanization: syllable)
                                pronunciations.append(pronunciation)
                        }
                        self.text = text
                        self.romanization = romanization
                        self.isMatched = isEqual
                        self.characterPronunciations = pronunciations
                } else {
                        self.text = text
                        self.romanization = romanization
                        self.isMatched = isEqual
                        self.characterPronunciations = []
                }
        }

        private let text: String
        private let romanization: String
        private let isMatched: Bool
        private let characterPronunciations: [CharacterPronunciation]

        var body: some View {
                if isMatched {
                        HStack(spacing: 1) {
                                ForEach(0..<characterPronunciations.count, id: \.self) { index in
                                        CharacterPronunciationView(characterPronunciation: characterPronunciations[index])
                                }
                        }
                        .contentShape(Rectangle())
                        .contextMenu {
                                MenuCopyButton(text, title: "Copy Cantonese Text")
                                MenuCopyButton(romanization, title: "Copy Jyutping Text")
                        }
                } else {
                        FallbackPronunciationView(text: text, romanization: romanization)
                }
        }
}

private struct CharacterPronunciation {
        let cantonese: String
        let romanization: String
}
private struct CharacterPronunciationView: View {
        let characterPronunciation: CharacterPronunciation
        var body: some View {
                VStack(spacing: 0) {
                        Text(verbatim: characterPronunciation.romanization)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .font(.footnote)
                        Text(verbatim: characterPronunciation.cantonese)
                                .font(.master)
                }
                .padding(.bottom, 4)
                .frame(width: 40)
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
