#if os(iOS)

import SwiftUI

struct PrivacyNoticeView: View {
        var body: some View {
                List {
                        Section {
                                VStack(spacing: 20) {
                                        NoteView("IOSHomeTab.PrivacyNotice.Row1")
                                        NoteView("IOSHomeTab.PrivacyNotice.Row2")
                                        NoteView("IOSHomeTab.PrivacyNotice.Row3")
                                        NoteView("IOSHomeTab.PrivacyNotice.Row4")
                                }
                                .padding(.vertical)
                        } footer: {
                                Text("IOSHomeTab.PrivacyNotice.Footer").textCase(nil)
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSHomeTab.NavigationTitle.PrivacyNotice")
                .navigationBarTitleDisplayMode(.inline)
        }
}

private struct NoteView: View {

        init(_ text: LocalizedStringKey) {
                self.text = text
        }

        private let text: LocalizedStringKey

        var body: some View {
                HStack {
                        Text.dotMark
                        Text(text)
                        Spacer()
                }
        }
}

#endif
