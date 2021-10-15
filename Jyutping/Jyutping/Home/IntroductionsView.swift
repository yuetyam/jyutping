import SwiftUI

@available(iOS 15.0, *)
struct IntroductionsView: View {
        var body: some View {
                List {
                        Text("Introductions")
                }
                .navigationTitle("title.introductions")
                .navigationBarTitleDisplayMode(.inline)
        }
}

@available(iOS 15.0, *)
struct IntroductionsView_Previews: PreviewProvider {
        static var previews: some View {
                IntroductionsView()
        }
}
