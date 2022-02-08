import SwiftUI

@available(iOS 14.0, *)
struct PrivacyNoticeView: View {

        var body: some View {
                List {
                        Section {
                                VStack(spacing: 20) {
                                        NoteView("privacy.notice.1")
                                        NoteView("privacy.notice.2")
                                        NoteView("privacy.notice.3")
                                        NoteView("privacy.notice.4")
                                }
                                .padding(.vertical)
                        } footer: {
                                Text("privacy.notice.footer").textCase(.none)
                        }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Privacy Notice")
                .navigationBarTitleDisplayMode(.inline)
        }
}


@available(iOS 14.0, *)
struct PrivacyNoticeView_Previews: PreviewProvider {
        static var previews: some View {
                PrivacyNoticeView()
        }
}


@available(iOS 14.0, *)
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
