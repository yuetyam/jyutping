import SwiftUI
import CommonExtensions

/// Workaround for { Cursor always jumps to the end when editing text }
struct SearchField: View {

        init(_ titleKey: LocalizedStringKey = "General.Search", submittedText: Binding<String>, submitLabel: SubmitLabel = .search) {
                self.titleKey = titleKey
                self._submittedText = submittedText
                self.submitLabel = submitLabel
        }

        private let titleKey: LocalizedStringKey
        @Binding private var submittedText: String
        private let submitLabel: SubmitLabel
        @State private var inputText: String = String.empty

        var body: some View {
                if #available(macOS 26.0, *) {
                        TextField(titleKey, text: $inputText)
                                #if os(iOS)
                                .textInputAutocapitalization(.never)
                                #endif
                                #if os(macOS)
                                .textFieldStyle(.plain)
                                #endif
                                .autocorrectionDisabled(true)
                                .submitLabel(submitLabel)
                                .onSubmit {
                                        submittedText = inputText
                                }
                                .font(.master)
                                .padding(8)
                                .glassEffect()
                } else {
                        TextField(titleKey, text: $inputText)
                                #if os(iOS)
                                .textInputAutocapitalization(.never)
                                #endif
                                #if os(macOS)
                                .textFieldStyle(.plain)
                                #endif
                                .autocorrectionDisabled(true)
                                .submitLabel(submitLabel)
                                .onSubmit {
                                        submittedText = inputText
                                }
                                .font(.master)
                                .padding(8)
                                .background(Color.textBackgroundColor.opacity(0.5), in: .capsule)
                }
        }
}
