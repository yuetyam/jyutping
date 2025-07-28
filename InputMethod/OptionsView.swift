import SwiftUI
import CoreIME
import CommonExtensions

struct OptionsView: View {

        @EnvironmentObject private var context: AppContext

        private let pageCornerRadius: CGFloat = CGFloat(AppSettings.pageCornerRadius)
        private let contentInsets: CGFloat = CGFloat(AppSettings.contentInsets)
        private let innerCornerRadius: CGFloat = CGFloat(AppSettings.innerCornerRadius)
        private let verticalPadding: CGFloat = CGFloat(AppSettings.candidateLineSpacing) / 2.0
        private let labelSet: LabelSet = AppSettings.labelSet
        private let isLabelLastZero: Bool = AppSettings.isLabelLastZero

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
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 0, highlightedIndex: highlightedIndex, text: options[0], checked: characterStandard == .traditional)
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 1, highlightedIndex: highlightedIndex, text: options[1], checked: characterStandard == .hongkong)
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 2, highlightedIndex: highlightedIndex, text: options[2], checked: characterStandard == .taiwan)
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 3, highlightedIndex: highlightedIndex, text: options[3], checked: characterStandard == .simplified)
                        }
                        Divider()
                        Group {
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 4, highlightedIndex: highlightedIndex, text: options[4], checked: characterForm.isHalfWidth)
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 5, highlightedIndex: highlightedIndex, text: options[5], checked: characterForm.isFullWidth)
                        }
                        Divider()
                        Group {
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 6, highlightedIndex: highlightedIndex, text: options[6], checked: punctuationForm.isCantoneseMode)
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 7, highlightedIndex: highlightedIndex, text: options[7], checked: punctuationForm.isEnglishMode)
                        }
                        Divider()
                        Group {
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 8, highlightedIndex: highlightedIndex, text: options[8], checked: inputMethodMode.isCantonese)
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 9, highlightedIndex: highlightedIndex, text: options[9], checked: inputMethodMode.isABC)
                        }
                }
                .padding(contentInsets)
                .background(HUDVisualEffect())
                .clipShape(RoundedRectangle(cornerRadius: pageCornerRadius, style: .continuous))
                .shadow(radius: 2)
                .padding(8)
                .fixedSize()
        }
}

private struct OptionLabel: View {

        init(cornerRadius: CGFloat, verticalPadding: CGFloat, labelSet: LabelSet, isLabelLastZero: Bool, index: Int, highlightedIndex: Int, text: String, checked: Bool) {
                self.cornerRadius = cornerRadius
                self.verticalPadding = verticalPadding
                self.labelText = LabelSet.labelText(for: index, labelSet: labelSet, isLabelLastZero: isLabelLastZero)
                self.index = index
                self.isHighlighted = index == highlightedIndex
                self.text = text
                self.checked = checked
        }

        private let cornerRadius: CGFloat
        private let verticalPadding: CGFloat
        private let index: Int
        private let isHighlighted: Bool
        private let labelText: String
        private let text: String
        private let checked: Bool

        var body: some View {
                HStack(spacing: 0) {
                        HStack(spacing: 6) {
                                Text(verbatim: labelText).font(.label).opacity(isHighlighted ? 1 : 0.75)
                                Text(verbatim: text).font(.candidate)
                        }
                        Spacer()
                        Image(systemName: "checkmark").font(.title3).opacity(checked ? 1 : 0)
                }
                .padding(.horizontal, 3)
                .padding(.vertical, verticalPadding)
                .foregroundStyle(isHighlighted ? Color.white : Color.primary)
                .background(isHighlighted ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .contentShape(Rectangle())
                .onHover { isHovering in
                        guard isHovering else { return }
                        guard isHighlighted.negative else { return }
                        NotificationCenter.default.post(name: .highlightIndex, object: nil, userInfo: [NotificationKey.highlightIndex : index])
                }
                .onTapGesture {
                        NotificationCenter.default.post(name: .selectIndex, object: nil, userInfo: [NotificationKey.selectIndex : index])
                }
        }
}
