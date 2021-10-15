import SwiftUI

@available(iOS 15.0, *)
struct FAQView: View {
        var body: some View {
                List {
                        Text("FAQ")
                }
                .navigationTitle("FAQ")
                .navigationBarTitleDisplayMode(.inline)
        }
}

@available(iOS 15.0, *)
struct FAQView_Previews: PreviewProvider {
        static var previews: some View {
                FAQView()
        }
}
