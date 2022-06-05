import SwiftUI


final class SettingsObject: ObservableObject {

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


struct SettingsView: View {

        @EnvironmentObject private var settingsObject: SettingsObject

        private let variant: Int = {
                switch Logogram.current {
                case .traditional:
                        return 0
                case .hongkong:
                        return 1
                case .taiwan:
                        return 2
                case .simplified:
                        return 3
                }
        }()

        private let textLine1: String = "傳統漢字\u{3000}\u{3000}\u{3000}"
        private let textLine2: String = "傳統漢字・香港"
        private let textLine3: String = "傳統漢字・臺灣"
        private let textLine4: String = "简化字\u{3000}\u{3000}\u{3000}\u{3000}"

        var body: some View {
                let highlightedIndex = settingsObject.highlightedIndex
                VStack(spacing: 3) {
                        Group {
                                SettingLabel(number: 1, text: textLine1, checked: variant == 0, highlighted: highlightedIndex == 0)
                                SettingLabel(number: 2, text: textLine2, checked: variant == 1, highlighted: highlightedIndex == 1)
                                SettingLabel(number: 3, text: textLine3, checked: variant == 2, highlighted: highlightedIndex == 2)
                                SettingLabel(number: 4, text: textLine4, checked: variant == 3, highlighted: highlightedIndex == 3)
                        }
                        Divider()
                        Group {
                                SettingLabel(number: 5, text: "半形數字", checked: true, highlighted: highlightedIndex == 4)
                                SettingLabel(number: 6, text: "全形數字（未實現）", checked: false, highlighted: highlightedIndex == 5)
                        }
                        Divider()
                        Group {
                                SettingLabel(number: 7, text: "粵文句讀", checked: true, highlighted: highlightedIndex == 6)
                                SettingLabel(number: 8, text: "英文標點（未實現）", checked: false, highlighted: highlightedIndex == 7)
                        }
                        Divider()
                        Group {
                                SettingLabel(number: 9, text: "有 Emoji", checked: InstantPreferences.needsEmojiCandidates, highlighted: highlightedIndex == 8)
                                SettingLabel(number: 0, text: "無 Emoji", checked: !(InstantPreferences.needsEmojiCandidates), highlighted: highlightedIndex == 9)
                        }
                }
                .padding(8)
                .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(.thinMaterial)
                                .shadow(radius: 4)
                )
        }
}


private struct SettingLabel: View {

        let number: Int
        let text: String
        let checked: Bool
        let highlighted: Bool

        var body: some View {
                HStack(spacing: 14) {
                        Text(verbatim: "\(number).").font(.serial)
                        Text(verbatim: text).font(.candidate)
                        if checked {
                                Image(systemName: "checkmark").font(.title2)
                        }
                        Spacer()
                }
                .padding(.leading, 8)
                .foregroundColor(highlighted ? .white : .primary)
                .background(highlighted ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
        }
}


struct InstantPreferences {

        /// 候選詞包含 Emoji
        private(set) static var needsEmojiCandidates: Bool = UserDefaults.standard.bool(forKey: "needs_emoji_candidates")
        static func updateNeedsEmojiCandidates(to newState: Bool) {
                needsEmojiCandidates = newState
                UserDefaults.standard.set(newState, forKey: "needs_emoji_candidates")
        }
}

