import SwiftUI
import CoreIME

struct OptionsView: View {

        @EnvironmentObject private var context: AppContext

        private let verticalPadding: CGFloat = CGFloat(AppSettings.candidateLineSpacing) / 2.0

        private let options: [String] = [
                String(localized: "OptionsView.CharacterStandard.Traditional"),
                String(localized: "OptionsView.CharacterStandard.TraditionalHongKong"),
                String(localized: "OptionsView.CharacterStandard.TraditionalTaiwan"),
                String(localized: "OptionsView.CharacterStandard.Simplified"),
                String(localized: "OptionsView.CharacterForm.HalfWidth"),
                String(localized: "OptionsView.CharacterForm.FullWidth"),
                String(localized: "OptionsView.PunctuationForm.Cantonese"),
                String(localized: "OptionsView.PunctuationForm.English"),
                String(localized: "OptionsView.InputMethodMode.Cantonese"),
                String(localized: "OptionsView.InputMethodMode.ABC")
        ]

        private let characterStandard: CharacterStandard = Options.characterStandard
        private let characterForm: CharacterForm = Options.characterForm
        private let punctuationForm: PunctuationForm = Options.punctuationForm
        private let inputMethodMode: InputMethodMode = Options.inputMethodMode

        var body: some View {
                let highlightedIndex = context.optionsHighlightedIndex
                VStack(alignment: .leading, spacing: 0) {
                        Group {
                                OptionLabel(verticalPadding: verticalPadding, index: 0, highlightedIndex: highlightedIndex, text: options[0], checked: characterStandard == .traditional)
                                OptionLabel(verticalPadding: verticalPadding, index: 1, highlightedIndex: highlightedIndex, text: options[1], checked: characterStandard == .hongkong)
                                OptionLabel(verticalPadding: verticalPadding, index: 2, highlightedIndex: highlightedIndex, text: options[2], checked: characterStandard == .taiwan)
                                OptionLabel(verticalPadding: verticalPadding, index: 3, highlightedIndex: highlightedIndex, text: options[3], checked: characterStandard == .simplified)
                        }
                        Divider()
                        Group {
                                OptionLabel(verticalPadding: verticalPadding, index: 4, highlightedIndex: highlightedIndex, text: options[4], checked: characterForm == .halfWidth)
                                OptionLabel(verticalPadding: verticalPadding, index: 5, highlightedIndex: highlightedIndex, text: options[5], checked: characterForm == .fullWidth)
                        }
                        Divider()
                        Group {
                                OptionLabel(verticalPadding: verticalPadding, index: 6, highlightedIndex: highlightedIndex, text: options[6], checked: punctuationForm == .cantonese)
                                OptionLabel(verticalPadding: verticalPadding, index: 7, highlightedIndex: highlightedIndex, text: options[7], checked: punctuationForm == .english)
                        }
                        Divider()
                        Group {
                                OptionLabel(verticalPadding: verticalPadding, index: 8, highlightedIndex: highlightedIndex, text: options[8], checked: inputMethodMode == .cantonese)
                                OptionLabel(verticalPadding: verticalPadding, index: 9, highlightedIndex: highlightedIndex, text: options[9], checked: inputMethodMode == .abc)
                        }
                }
                .padding(4)
                .roundedHUDVisualEffect()
                .fixedSize()
                .padding(10)
        }
}

private struct OptionLabel: View {

        let verticalPadding: CGFloat
        let index: Int
        let highlightedIndex: Int
        let text: String
        let checked: Bool

        var body: some View {
                let serialNumber: String = (index == 9) ? "0" : "\(index + 1)"
                let isHighlighted: Bool = index == highlightedIndex
                HStack(spacing: 0) {
                        HStack(spacing: 8) {
                                Text(verbatim: serialNumber).font(.label).opacity(isHighlighted ? 1 : 0.66)
                                Text(verbatim: text).font(.candidate)
                        }
                        Spacer()
                        Image(systemName: "checkmark").font(.title3).opacity(checked ? 1 : 0)
                }
                .padding(.horizontal, 4)
                .padding(.vertical, verticalPadding)
                .foregroundStyle(isHighlighted ? Color.white : Color.primary)
                .background(isHighlighted ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
        }
}
