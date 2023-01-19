#if os(macOS)

import SwiftUI

/// Workaround for: Cursor always jumps to the end when editing text
struct SearchField: View {

        init(_ titleKey: LocalizedStringKey = "Search", submittedText: Binding<String>) {
                self.titleKey = titleKey
                self._submittedText = submittedText
        }

        private let titleKey: LocalizedStringKey
        @Binding private var submittedText: String
        @State private var inputText: String = ""

        var body: some View {
                TextField(titleKey, text: $inputText)
                        .textFieldStyle(.plain)
                        .disableAutocorrection(true)
                        .submitLabel(.search)
                        .onSubmit {
                                submittedText = inputText
                        }
        }
}

#endif
