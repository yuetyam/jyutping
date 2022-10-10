import SwiftUI


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

        private let variant: Int = {
                switch Logogram.current {
                case .traditional:
                        return 1
                case .hongkong:
                        return 2
                case .taiwan:
                        return 3
                case .simplified:
                        return 4
                }
        }()

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

        var body: some View {
                let highlightedIndex = settingsObject.highlightedIndex
                VStack(alignment: .leading, spacing: 0) {
                        Group {
                                SettingLabel(index: 0, text: textLine1, checked: variant == 1, highlighted: highlightedIndex == 0)
                                SettingLabel(index: 1, text: textLine2, checked: variant == 2, highlighted: highlightedIndex == 1)
                                SettingLabel(index: 2, text: textLine3, checked: variant == 3, highlighted: highlightedIndex == 2)
                                SettingLabel(index: 3, text: textLine4, checked: variant == 4, highlighted: highlightedIndex == 3)
                        }
                        Divider()
                        Group {
                                SettingLabel(index: 4, text: options.textLine5, checked: InstantSettings.characterForm == .halfWidth, highlighted: highlightedIndex == 4)
                                SettingLabel(index: 5, text: options.textLine6, checked: InstantSettings.characterForm == .fullWidth, highlighted: highlightedIndex == 5)
                        }
                        Divider()
                        Group {
                                SettingLabel(index: 6, text: options.textLine7, checked: InstantSettings.punctuation == .cantonese, highlighted: highlightedIndex == 6)
                                SettingLabel(index: 7, text: options.textLine8, checked: InstantSettings.punctuation == .english, highlighted: highlightedIndex == 7)
                        }
                        Divider()
                        Group {
                                SettingLabel(index: 8, text: options.textLine9, checked: InstantSettings.needsEmojiCandidates, highlighted: highlightedIndex == 8)
                                SettingLabel(index: 9, text: options.textLine10, checked: !(InstantSettings.needsEmojiCandidates), highlighted: highlightedIndex == 9)
                        }
                }
                .padding(8)
        }
}


private struct SettingLabel: View {

        let index: Int
        let text: String
        let checked: Bool
        let highlighted: Bool

        private let componentsSpacing: CGFloat = 14

        var body: some View {
                ZStack(alignment: .leading) {
                        HStack(spacing: componentsSpacing) {
                                SerialNumberLabel(7)
                                Text(verbatim: "傳統漢字・香港").font(.candidate)
                                Image(systemName: "checkmark").font(.title2)
                        }
                        .opacity(0)
                        HStack(spacing: componentsSpacing) {
                                SerialNumberLabel(index)
                                Text(verbatim: text).font(.candidate)
                                if checked {
                                        Image(systemName: "checkmark").font(.title2)
                                }
                        }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .foregroundColor(highlighted ? .white : .primary)
                .background(highlighted ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
        }
}

