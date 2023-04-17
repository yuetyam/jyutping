import SwiftUI
import CoreIME

final class SwitchesObject: ObservableObject {

        @Published private(set) var highlightedIndex: Int = 0

        private let minIndex: Int = 0
        private let maxIndex: Int = 9

        func increaseHighlightedIndex() {
                guard highlightedIndex < maxIndex else { return }
                highlightedIndex += 1
        }
        func decreaseHighlightedIndex() {
                guard highlightedIndex > minIndex else { return }
                highlightedIndex -= 1
        }
        func resetHighlightedIndex() {
                highlightedIndex = minIndex
        }
}

/// InstantSettings switches
struct SwitchesView: View {

        @EnvironmentObject private var switchesObject: SwitchesObject

        private let verticalPadding: CGFloat = CGFloat(AppSettings.candidateLineSpacing) / 2.0

        private let options: [String] = {
                let variants: [String] = [
                        "傳統漢字\u{3000}\u{3000}\u{3000}",
                        "傳統漢字・香港",
                        "傳統漢字・臺灣",
                        "简化字\u{3000}\u{3000}\u{3000}\u{3000}"
                ]
                let traditional: [String] = [
                        "半形數字",
                        "全形數字",
                        "粵文句讀",
                        "英文標點",
                        "表情符號",
                        "無\u{3000}\u{3000}\u{3000}"
                ]
                let simplified: [String] = [
                        "半形数字",
                        "全形数字",
                        "粤文句读",
                        "英文标点",
                        "表情符号",
                        "无\u{3000}\u{3000}\u{3000}"
                ]
                return (Logogram.current == .simplified) ? (variants + simplified) : (variants + traditional)
        }()

        private let currentVariant: Logogram = Logogram.current

        var body: some View {
                let highlightedIndex = switchesObject.highlightedIndex
                VStack(alignment: .leading, spacing: 0) {
                        Group {
                                SettingLabel(verticalPadding: verticalPadding, index: 0, highlightedIndex: highlightedIndex, text: options[0], checked: currentVariant == .traditional)
                                SettingLabel(verticalPadding: verticalPadding, index: 1, highlightedIndex: highlightedIndex, text: options[1], checked: currentVariant == .hongkong)
                                SettingLabel(verticalPadding: verticalPadding, index: 2, highlightedIndex: highlightedIndex, text: options[2], checked: currentVariant == .taiwan)
                                SettingLabel(verticalPadding: verticalPadding, index: 3, highlightedIndex: highlightedIndex, text: options[3], checked: currentVariant == .simplified)
                        }
                        Divider()
                        Group {
                                SettingLabel(verticalPadding: verticalPadding, index: 4, highlightedIndex: highlightedIndex, text: options[4], checked: InstantSettings.characterForm == .halfWidth)
                                SettingLabel(verticalPadding: verticalPadding, index: 5, highlightedIndex: highlightedIndex, text: options[5], checked: InstantSettings.characterForm == .fullWidth)
                        }
                        Divider()
                        Group {
                                SettingLabel(verticalPadding: verticalPadding, index: 6, highlightedIndex: highlightedIndex, text: options[6], checked: InstantSettings.punctuation == .cantonese)
                                SettingLabel(verticalPadding: verticalPadding, index: 7, highlightedIndex: highlightedIndex, text: options[7], checked: InstantSettings.punctuation == .english)
                        }
                        Divider()
                        Group {
                                SettingLabel(verticalPadding: verticalPadding, index: 8, highlightedIndex: highlightedIndex, text: options[8], checked: InstantSettings.needsEmojiCandidates)
                                SettingLabel(verticalPadding: verticalPadding, index: 9, highlightedIndex: highlightedIndex, text: options[9], checked: !(InstantSettings.needsEmojiCandidates))
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
