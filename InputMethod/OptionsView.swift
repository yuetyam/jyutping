import SwiftUI
import CoreIME
import CommonExtensions

struct OptionsView: View {

        @EnvironmentObject private var context: InputContext

        private let innerCornerRadius: CGFloat = CGFloat(AppSettings.innerCornerRadius)
        private let verticalPadding: CGFloat = CGFloat(AppSettings.candidateLineSpacing) / 2.0
        private let labelSet: LabelSet = AppSettings.labelSet
        private let isLabelLastZero: Bool = AppSettings.isLabelLastZero

        private let characterStandard: CharacterStandard = Options.legacyCharacterStandard
        private let characterForm: CharacterForm = Options.characterForm
        private let punctuationForm: PunctuationForm = Options.punctuationForm
        private let inputMethodMode: InputMethodMode = Options.inputMethodMode

        var body: some View {
                let highlightedIndex = context.optionsHighlightedIndex
                VStack(alignment: .leading, spacing: 0) {
                        Group {
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 0, highlightedIndex: highlightedIndex, checked: characterStandard == .preset)
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 1, highlightedIndex: highlightedIndex, checked: characterStandard == .hongkong)
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 2, highlightedIndex: highlightedIndex, checked: characterStandard == .taiwan)
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 3, highlightedIndex: highlightedIndex, checked: characterStandard == .mutilated)
                        }
                        Divider()
                        Group {
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 4, highlightedIndex: highlightedIndex, checked: characterForm.isHalfWidth)
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 5, highlightedIndex: highlightedIndex, checked: characterForm.isFullWidth)
                        }
                        Divider()
                        Group {
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 6, highlightedIndex: highlightedIndex, checked: punctuationForm.isCantoneseMode)
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 7, highlightedIndex: highlightedIndex, checked: punctuationForm.isEnglishMode)
                        }
                        Divider()
                        Group {
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 8, highlightedIndex: highlightedIndex, checked: inputMethodMode.isCantonese)
                                OptionLabel(cornerRadius: innerCornerRadius, verticalPadding: verticalPadding, labelSet: labelSet, isLabelLastZero: isLabelLastZero, index: 9, highlightedIndex: highlightedIndex, checked: inputMethodMode.isABC)
                        }
                }
        }
}

private struct OptionLabel: View {

        init(cornerRadius: CGFloat, verticalPadding: CGFloat, labelSet: LabelSet, isLabelLastZero: Bool, index: Int, highlightedIndex: Int, checked: Bool) {
                self.cornerRadius = cornerRadius
                self.verticalPadding = verticalPadding
                self.labelText = LabelSet.labelText(for: index, labelSet: labelSet, isLabelLastZero: isLabelLastZero)
                self.index = index
                self.isHighlighted = index == highlightedIndex
                self.checked = checked
        }
        private let cornerRadius: CGFloat
        private let verticalPadding: CGFloat
        private let index: Int
        private let isHighlighted: Bool
        private let labelText: String
        private let checked: Bool

        var body: some View {
                ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(isHighlighted ? Color.accentColor : Color.clear)
                        HStack(spacing: 0) {
                                HStack(spacing: 6) {
                                        Text(labelText).font(.label).opacity(isHighlighted ? 1 : 0.75)
                                        Text(PresetConstant.optionsViewTexts[index] ?? "?").font(.candidate)
                                }
                                Spacer()
                                Image(systemName: "checkmark").font(.title3).opacity(checked ? 1 : 0)
                        }
                        .foregroundStyle(isHighlighted ? Color.white : Color.primary)
                        .padding(.horizontal, 3)
                        .padding(.vertical, verticalPadding)
                }
                .contentShape(.rect)
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
