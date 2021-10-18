import SwiftUI

@available(iOS 14.0, *)
struct IntroductionsView: View {
        var body: some View {
                List {
                        Section {
                                Text("Period (Full Stop) Shortcut").font(.headline)
                                Text("Double tapping the space bar will insert a period followed by a space")
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
