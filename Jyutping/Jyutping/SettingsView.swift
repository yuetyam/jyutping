import SwiftUI


final class SettingsObject: ObservableObject {

        @Published private(set) var highlightedIndex: Int = 0

        func increaseHighlightedIndex() {
                guard highlightedIndex < 4 else { return }
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

        @State var shapeSelection: Int = 0
        @State var punctuationSelection: Int = 0
        @State var emojiStateSelection: Int = 0

        var body: some View {
                VStack(spacing: 8) {
                        HStack {
                                Text(verbatim: "1.").font(.serialNumber)
                                Text(verbatim: "退出").font(.candidate)
                                Spacer()
                        }
                        .foregroundColor(settingsObject.highlightedIndex == 0 ? .blue : .primary)

                        LogogramLabel(number: 2, text: "傳統漢字\u{3000}\u{3000}\u{3000}", checked: variant == 0, highlighted: settingsObject.highlightedIndex == 1)
                        LogogramLabel(number: 3, text: "傳統漢字・香港", checked: variant == 1, highlighted: settingsObject.highlightedIndex == 2)
                        LogogramLabel(number: 4, text: "傳統漢字・臺灣", checked: variant == 2, highlighted: settingsObject.highlightedIndex == 3)
                        LogogramLabel(number: 5, text: "简化字\u{3000}\u{3000}\u{3000}\u{3000}", checked: variant == 3, highlighted: settingsObject.highlightedIndex == 4)

                        /*
                        HStack {
                                Text(verbatim: "6.").font(.serialNumber)
                                Picker("Shape", selection: $shapeSelection) {
                                        Text(verbatim: "半形數字").tag(0)
                                        Text(verbatim: "全形數字").tag(1)
                                }
                                .labelsHidden()
                                .pickerStyle(.segmented)
                                Spacer()
                        }
                        .foregroundColor(settingsObject.highlightedIndex == 5 ? .blue : .primary)

                        HStack {
                                Text(verbatim: "7.").font(.serialNumber)
                                Picker("Punctuation", selection: $punctuationSelection) {
                                        Text(verbatim: "粵文句讀。").tag(0)
                                        Text(verbatim: "英文標點 .").tag(1)
                                }
                                .labelsHidden()
                                .pickerStyle(.segmented)
                                Spacer()
                        }
                        .foregroundColor(settingsObject.highlightedIndex == 6 ? .blue : .primary)
                        */
                }
                .padding()
                .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}


private struct LogogramLabel: View {

        let number: Int
        let text: String
        let checked: Bool
        let highlighted: Bool

        var body: some View {
                HStack {
                        Text(verbatim: "\(number).").font(.serialNumber)
                        Text(verbatim: text).font(.candidate)
                        if checked {
                                Image(systemName: "checkmark").font(.title3)
                        }
                        Spacer()
                }
                .foregroundColor(highlighted ? .blue : .primary)
        }
}
