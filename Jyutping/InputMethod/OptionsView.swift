import SwiftUI
import CoreIME

struct OptionsView: View {

        @EnvironmentObject private var context: AppContext

        private let verticalPadding: CGFloat = CGFloat(AppSettings.candidateLineSpacing) / 2.0

        private let options: [String] = [
                "傳統漢字\u{3000}\u{3000}\u{3000}",
                "傳統漢字・香港",
                "傳統漢字・臺灣",
                "簡化字\u{3000}\u{3000}\u{3000}\u{3000}",
                "半形數字",
                "全形數字",
                "粵文句讀",
                "英文標點",
                "表情符號",
                "無\u{3000}\u{3000}\u{3000}"
        ]

        private let characterStandard: CharacterStandard = Options.characterStandard
        private let characterForm: CharacterForm = Options.characterForm
        private let punctuationForm: PunctuationForm = Options.punctuationForm
        private let needsEmojiCandidates: Bool = Options.isEmojiSuggestionsOn

        var body: some View {
                let highlightedIndex = context.optionsHighlightedIndex
                VStack(alignment: .leading, spacing: 0) {
                        Group {
                                SettingLabel(verticalPadding: verticalPadding, index: 0, highlightedIndex: highlightedIndex, text: options[0], checked: characterStandard == .traditional)
                                SettingLabel(verticalPadding: verticalPadding, index: 1, highlightedIndex: highlightedIndex, text: options[1], checked: characterStandard == .hongkong)
                                SettingLabel(verticalPadding: verticalPadding, index: 2, highlightedIndex: highlightedIndex, text: options[2], checked: characterStandard == .taiwan)
                                SettingLabel(verticalPadding: verticalPadding, index: 3, highlightedIndex: highlightedIndex, text: options[3], checked: characterStandard == .simplified)
                        }
                        Divider()
                        Group {
                                SettingLabel(verticalPadding: verticalPadding, index: 4, highlightedIndex: highlightedIndex, text: options[4], checked: characterForm == .halfWidth)
                                SettingLabel(verticalPadding: verticalPadding, index: 5, highlightedIndex: highlightedIndex, text: options[5], checked: characterForm == .fullWidth)
                        }
                        Divider()
                        Group {
                                SettingLabel(verticalPadding: verticalPadding, index: 6, highlightedIndex: highlightedIndex, text: options[6], checked: punctuationForm == .cantonese)
                                SettingLabel(verticalPadding: verticalPadding, index: 7, highlightedIndex: highlightedIndex, text: options[7], checked: punctuationForm == .english)
                        }
                        Divider()
                        Group {
                                SettingLabel(verticalPadding: verticalPadding, index: 8, highlightedIndex: highlightedIndex, text: options[8], checked: needsEmojiCandidates)
                                SettingLabel(verticalPadding: verticalPadding, index: 9, highlightedIndex: highlightedIndex, text: options[9], checked: !needsEmojiCandidates)
                        }
                }
                .padding(8)
                .roundedHUDVisualEffect()
                .fixedSize()
        }
}

private struct SettingLabel: View {

        let verticalPadding: CGFloat
        let index: Int
        let highlightedIndex: Int
        let text: String
        let checked: Bool

        private let placeholder: String = "傳統漢字・香港"

        var body: some View {
                let serialNumber: String = index == 9 ? "0" : "\(index + 1)"
                let isHighlighted: Bool = index == highlightedIndex
                ZStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                Text(verbatim: serialNumber).font(.label)
                                Text(verbatim: placeholder).font(.candidate)
                                Image(systemName: "checkmark").font(.title2)
                        }
                        .hidden()
                        HStack(spacing: 16) {
                                Text(verbatim: serialNumber).font(.label)
                                Text(verbatim: text).font(.candidate)
                                if checked {
                                        Image(systemName: "checkmark").font(.title2)
                                }
                        }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, verticalPadding)
                .foregroundColor(isHighlighted ? .white : .primary)
                .background(isHighlighted ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
        }
}
