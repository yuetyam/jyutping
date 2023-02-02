import SwiftUI
import CoreIME

final class InstantSettingsObject: ObservableObject {

        @Published private(set) var highlightedIndex: Int = 0

        func increaseHighlightedIndex() {
                guard highlightedIndex < 9 else { return }
                highlightedIndex += 1
        }
        func decreaseHighlightedIndex() {
                guard highlightedIndex > 0 else { return }
                highlightedIndex -= 1
        }
        func resetHighlightedIndex() {
                highlightedIndex = 0
        }
}


struct InstantSettingsView: View {

        @EnvironmentObject private var settingsObject: InstantSettingsObject

        private let verticalPadding: CGFloat = CGFloat(AppSettings.candidateLineSpacing) / 2.0

        private let textLine1: String = "傳統漢字\u{3000}\u{3000}\u{3000}"
        private let textLine2: String = "傳統漢字・香港"
        private let textLine3: String = "傳統漢字・臺灣"
        private let textLine4: String = "简化字\u{3000}\u{3000}\u{3000}\u{3000}"

        private struct LabelLines {
                let textLine5: String
                let textLine6: String
                let textLine7: String
                let textLine8: String
                let textLine9: String
                let textLine10: String
        }
        private let options: LabelLines = {
                switch Logogram.current {
                case .simplified:
                        return LabelLines(textLine5: "半形数字", textLine6: "全形数字", textLine7: "粤文句读", textLine8: "英文标点", textLine9: "有 Emoji", textLine10: "无 Emoji")
                default:
                        return LabelLines(textLine5: "半形數字", textLine6: "全形數字", textLine7: "粵文句讀", textLine8: "英文標點", textLine9: "有 Emoji", textLine10: "無 Emoji")
                }
        }()

        private let currentVariant: Logogram = Logogram.current

        var body: some View {
                let highlightedIndex = settingsObject.highlightedIndex
                VStack(alignment: .leading, spacing: 0) {
                        Group {
                                SettingLabel(verticalPadding: verticalPadding, index: 0, highlightedIndex: highlightedIndex, text: textLine1, checked: currentVariant == .traditional)
                                SettingLabel(verticalPadding: verticalPadding, index: 1, highlightedIndex: highlightedIndex, text: textLine2, checked: currentVariant == .hongkong)
                                SettingLabel(verticalPadding: verticalPadding, index: 2, highlightedIndex: highlightedIndex, text: textLine3, checked: currentVariant == .taiwan)
                                SettingLabel(verticalPadding: verticalPadding, index: 3, highlightedIndex: highlightedIndex, text: textLine4, checked: currentVariant == .simplified)
                        }
                        Divider()
                        Group {
                                SettingLabel(verticalPadding: verticalPadding, index: 4, highlightedIndex: highlightedIndex, text: options.textLine5, checked: InstantSettings.characterForm == .halfWidth)
                                SettingLabel(verticalPadding: verticalPadding, index: 5, highlightedIndex: highlightedIndex, text: options.textLine6, checked: InstantSettings.characterForm == .fullWidth)
                        }
                        Divider()
                        Group {
                                SettingLabel(verticalPadding: verticalPadding, index: 6, highlightedIndex: highlightedIndex, text: options.textLine7, checked: InstantSettings.punctuation == .cantonese)
                                SettingLabel(verticalPadding: verticalPadding, index: 7, highlightedIndex: highlightedIndex, text: options.textLine8, checked: InstantSettings.punctuation == .english)
                        }
                        Divider()
                        Group {
                                SettingLabel(verticalPadding: verticalPadding, index: 8, highlightedIndex: highlightedIndex, text: options.textLine9, checked: InstantSettings.needsEmojiCandidates)
                                SettingLabel(verticalPadding: verticalPadding, index: 9, highlightedIndex: highlightedIndex, text: options.textLine10, checked: !(InstantSettings.needsEmojiCandidates))
                        }
                }
                .padding(8)
                .roundedHUDVisualEffect()
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
