import SwiftUI

@available(iOS 14.0, *)
struct IntroductionsView: View {
        var body: some View {
                List {
                        Section {
                                Text("Period (Full Stop) Shortcut").font(.headline)
                                Text("Double tapping the space bar will insert a period followed by a space")
                        }
                        Section {
                                Text(verbatim: "一次過清除已輸入音節").font(.headline)
                                Text(verbatim: "喺刪除掣(Delete)度向左滑，即可一次過刪晒已輸入拼寫")
                        }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("title.introductions")
                .navigationBarTitleDisplayMode(.inline)
        }
}

@available(iOS 14.0, *)
struct IntroductionsView_Previews: PreviewProvider {
        static var previews: some View {
                IntroductionsView()
        }
}
