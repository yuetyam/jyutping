import SwiftUI

@available(iOS 14.0, *)
struct PrivacyNoticeView: View {

        var body: some View {
                List {
                        VStack(spacing: 16) {
                                NoteView("鍵盤全程毋會訪問網絡")
                                NoteView("鍵盤係完全獨立个，同主應用程式之間毋會進行任何交流、分享")
                        }
                        .padding(.vertical)
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
